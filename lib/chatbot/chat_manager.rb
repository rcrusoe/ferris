class ChatManager
  include Reply
  include Rails.application.routes.url_helpers

  def initialize(convo)
    @convo = convo
    @user = @convo.user
  end

  # based on conversation state, generate a response
  # TODO return a list of [message1, message2] instead one a single message
  def reply(msg)
    response = []
    # -----------------------------------------------------------------
    #  STATE 0 -- ONBOARDING
    # -----------------------------------------------------------------
    if @convo.new_request?
      if @user.new?
        @convo.update(state: 'discovery_method')
        response << Reply::HELLO_NEW
      else
        @convo.update(state: 'when')
        if @user.name?
          response << Reply::HELLO_NAME % {name: @user.name}
        else
          response << Reply::HELLO_NO_NAME
        end
      end

    elsif @convo.discovery_method?
      @convo.update(state: 'local_or_visitor')
      response << Reply::LOCAL_OR_TRAVELER

    elsif @convo.local_or_visitor?
      # TODO: record local or visitor, change convo flow based on answer
      @convo.update(state: 'when')
      response << Reply::HOW_IT_WORKS
      response << Reply::WHEN_NEW_USER

    # -----------------------------------------------------------------
    #  STATE 1 -- WHEN
    # -----------------------------------------------------------------
    elsif @convo.when?
      timespan = extract_timeSpan(msg)
      if timespan
        @convo.update(pref_begin_time: timespan.begin, pref_end_time: timespan.end-1)
        event = Event.where(date: @convo.pref_begin_time..@convo.pref_end_time).sample
        response << Reply::EVENT_DETAILS % {title: event.title,
                                        date: stringify_date(event),
                                        time: event.start_time.strftime('%l%P'),
                                        location: event.place.neighborhood,
                                        url: event_url(event, host: 'joinferris.com')}
      else
        response << Reply::WHEN_TRY_AGAIN
      end

    else
      response << "Something is broken, I'm still learning"
    end

    response

    # # first let's split the message into sentences and then tokens
    # text = paragraph message
    # text.apply(:segment, :tokenize, :category, :tag)
    # ap text.sentences.first.numbers
  end

  private

  # extract date range from string
  def extract_timeSpan(s)
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"
    s.gsub!('!', '')
    s.gsub!('?', '') if s.chars.count > 1
    s.gsub!('/', ' ')
    parsed = Chronic.parse(s, :guess => false)

    if parsed.nil?
      n = Nickel.parse s
      if n.occurrences.any?
        parsed = n.occurrences[0].start_date.date
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
            parsed = n.occurrences[0].start_date.date
          end
        end
        break unless parsed.nil?
      end
    end

    # manually check for certain ones
    if s.downcase == 'later' || s.downcase == 'both'
      parsed = Date.today
    end

    parsed
  end

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
end