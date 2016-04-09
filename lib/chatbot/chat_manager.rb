class ChatManager
  include Reply, Tags
  include Rails.application.routes.url_helpers

  def initialize(convo)
    @convo = convo
    @user = @convo.user
  end

  # based on conversation state, generate a response
  def reply(msg)
    response = []
    # -----------------------------------------------------------------
    # PASSIVE EXTRACTION - (Timespan, Location, Categories)
    # -----------------------------------------------------------------
    extract_commands(msg)
    extract_location(msg)
    extract_timeSpan(msg)
    extract_categories(msg)

    # -----------------------------------------------------------------
    #  STATE 0 -- ONBOARDING
    # -----------------------------------------------------------------
    if @convo.new_request?
      if @user.new?
        @convo.update(state: 'get_name')
        response << Reply::HELLO_NEW
      else
        @convo.update(state: 'when')
        response << Reply::HELLO_NAME % {name: @user.name_str}
      end

    elsif @convo.get_name?
      extract_name(msg)
      response << Reply::LOCAL_OR_TRAVELER % {name: @user.name_str}
      @convo.update(state: 'local_or_visitor')

    elsif @convo.local_or_visitor?
      extract_local(msg)
      if @user.local?
        @convo.update(state: 'when')
        response << Reply::HOW_IT_WORKS
      else
        @convo.update(state: 'what')
        response << Reply::HOW_IT_WORKS_TOURIST
      end

    # -----------------------------------------------------------------
    #  STATE 1 -- WHEN
    # -----------------------------------------------------------------
    elsif @convo.when?
      if @convo.pref_begin_time?
        @convo.update(state: 'what')
        response << Reply::WHAT

      else
        response << Reply::WHEN_TRY_AGAIN
      end
    # -----------------------------------------------------------------
    #  STATE 2 -- WHAT - categories & keywords
    # -----------------------------------------------------------------
    elsif @convo.what?
      # if @convo.pref_categories? || msg.includes?('any')
        # if categories is set, return 3 events sorted by interested_count

        events = Event.recommend(@convo)
        events.each_with_index do |event, i|
          unless event.place.nil?
            response << Reply::EVENT_DETAILS % {title: event.title,
                                                date: stringify_date(event),
                                                time: event.start_time.strftime('%l%P'),
                                                location: event.place.neighborhood,
                                                url: event_url(event, host: 'joinferris.com')}
          end
          break if i > 1
        end

        # @convo.update(state: 'confirmation')
      # else
      #   response << Reply::HELP % {name: ' '+@user.name_str}
      # end
    elsif @convo.confirmation?
      # look for sentiment analysis positive / negative
      # look for 'more' keyword
    elsif @convo.reset?
      response << "Goodbye#{@user.name_str}. Reseting..."
      @user.destroy
    else
        response << "There was an error, I'm still learning..."
    end

    response
  end

  private

  # extract a generic list of commands on every input
  def extract_commands(cmd)
    if cmd.downcase == 'reset'
      @convo.update(state: 'reset')
    end
  end

  def extract_categories(str)
    tgr = EngTagger.new
    # stmr= Lingua::Stemmer.new
    str = normalize(str)

    tagged = tgr.add_tags(str.downcase)
    nouns = tgr.get_nouns(tagged)
    tags = []
    nouns.keys.each do |word|
      word = word.singularize
      # word = stmr.stem(word)
      tags << word if Tags::keyword?(word)
    end

    @convo.update(pref_categories: tags.join(',')) unless tags.empty?
  end

  # extract location from message
  def extract_location(msg)
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"
    results = AlchemyAPI.search(:entity_extraction, text: msg)
    results.each do |entity|
      if entity['type'] == 'City' || entity['type'] == 'Country' || entity['type'] == 'GeographicFeature'
        location = entity['text']
        @convo.update(pref_location: location)
      end
    end
  end

  # extract date range from message
  def extract_timeSpan(s)
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"

    # normalization of punctuation characters
    s.gsub!('!', '')
    s.gsub!('?', '') if s.chars.count > 1
    s.gsub!('/', ' ')
    s.gsub!('-', ' ')
    s.gsub!('.', '')

    parsed = Chronic.parse(s, :guess => false)

    if parsed.nil?
      n = Nickel.parse s
      if n.occurrences.any?
        parsed = Date.parse(n.occurrences[0].start_date.date)
      end
    end

    # second fallback is on Alchemy API
    if parsed.nil?
      results = AlchemyAPI.search(:keyword_extraction, text: s)
      results.each do |r|
        parsed = Chronic.parse(r['text'], :guess => false)
        if parsed.nil?
          n = Nickel.parse r['text']
          if n.occurrences.any?
            parsed = Date.parse(n.occurrences[0].start_date.date)
          end
        end
        break unless parsed.nil?
      end
    end

    # manually check for certain strings
    if s.downcase == 'later' || s.downcase == 'both'
      parsed = Date.today
    end

    # if date extracted, update conversation object
    unless parsed.nil?
      if parsed.is_a? Chronic::Span
        @convo.update(pref_begin_time: parsed.begin, pref_end_time: parsed.end-1)
      else
        @convo.update(pref_begin_time: parsed, pref_end_time: parsed)
      end
    end
  end

  def extract_name(msg)
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"
    results = AlchemyAPI.search(:entity_extraction, text: msg)
    return if results.nil?
    results.each do |tag|
      if tag['type'] == 'Person'
        @user.update(name: tag['text'].titleize)
      end
    end
  end

  # is the user a local or visitor? default to true if can't parse msg
  def extract_local(msg)
    local_words = ['local', 'live here', 'from here']
    visitor_words = ['visit', 'vacation', 'travel', 'tour']
    if local_words.any? { |word| msg.include?(word) }
      @user.update(local: true)
    elsif visitor_words.any? { |word| msg.include?(word) }
      @user.update(local: false)
    else
      @user.update(local: true)
    end
  end

  # TODO: move to events
  # produces natural language for the user's desired timespan
  def stringify_date(event)
    if event.next.date.today?
      if event.start_time.hour > Time.parse("5pm").hour
        'tonight'
      else
        'today'
      end
    elsif event.next.date == Date.current.tomorrow
      if event.start_time.hour > Time.parse("5pm").hour
        'tomorrow night'
      else
        'tomorrow'
      end
    else
      'on ' + event.date.strftime("%A, %B #{event.date.day.ordinalize}")
    end
  end

  def normalize(s)
    s.gsub!('!', '')
    s.gsub!('?', '') if s.chars.count > 1
    s.gsub!('/', ' ')
    s.gsub!('-', ' ')
    s.gsub!('.', '')
    return s
  end
end