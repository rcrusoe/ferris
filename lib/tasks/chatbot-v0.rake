namespace :bot do
  # https://github.com/louismullie/treat
  #============================================================================
  # Basic
  #============================================================================
  desc 'Named Entity Recognition'
  task :who => :environment do
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"
    tgr = EngTagger.new

    strings = []
    Conversation.all.order('created_at desc').each do |c|
      c.messages.each_with_index do |msg, index|
        # message before last includes date
        if msg.body.include?("name") && c.messages[index+1].present? && c.messages[index+1].inbound?
          strings << c.messages[index+1].body
        end
      end
    end

    count = 0
    strings.each_with_index do |s, i|
      ap s
      tagged = tgr.add_tags(s)
      name = tgr.get_proper_nouns(tagged)

      unless name.nil?
        count += 1
        ap name
      end
      break if i > 98
    end

    ap count.to_s + ' / 100'
  end

  desc 'Date Recognition'
  task :when => :environment do
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"

    strings = []
    Conversation.all.order('created_at desc').each do |c|
      c.messages.each_with_index do |msg, index|
        # message before last includes date
        strings << c.messages[index+1].body if msg.body.include? "Sure! There's so many great options"
      end
    end

    dates = []
    strings.each do |s|
      ap s
      s.gsub!('!', '')
      s.gsub!('?', '') if s.chars.count > 1
      s.gsub!('/', ' ')
      s.gsub!('-', ' ')
      s.gsub!('.', '')
      # ap s
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
          begin
            parsed = Chronic.parse(r['text'], :guess => false)
          rescue ArgumentError
            ap 'ERROR CAUGHT!'
            next
          end
          if parsed.nil?
            n = Nickel.parse r['text']
            if n.occurrences.any?
              parsed = Date.parse(n.occurrences[0].start_date.date)
            end
          end
          break unless parsed.nil?
        end
      end

      # manually check for certain ones
      if s.downcase == 'later' || s.downcase == 'both'
        parsed = Date.today
      end

      unless parsed.nil?
        dates << parsed
        ap parsed.is_a? Chronic::Span
      end
      ap 'FAILURE' if parsed.nil?
    end
    puts "#{dates.count} / #{strings.count}"
  end

  desc 'Category Extraction'
  task :what => :environment do
    strings = []
    Conversation.order('RANDOM()').limit(10).each do |c|
      c.messages.each_with_index do |msg, index|
        # message before last includes date
        if (msg.body.include?("What sort of") || msg.body.include?("what type of")) && c.messages[index+1].present?
          if c.messages[index+1].inbound?
            strings << c.messages[index+1].body
          end
        end
      end
    end

    all_nouns = Hash.new
    all_adjectives = Hash.new
    tgr = EngTagger.new
    strings.each_with_index do |str, i|
      # remove symbols
      str = normalize(str)
      ap str

      tagged = tgr.add_tags(str.downcase)
      nouns = tgr.get_nouns(tagged)
      nouns.each do |k, v|
        k = k.singularize
        if all_nouns.key?(k)
          all_nouns[k] += v
        else
          all_nouns[k] = v
        end
      end

      adjectives = tgr.get_adjectives(tagged)
      adjectives.each do |k, v|
        if all_adjectives.key?(k)
          all_adjectives[k] += v
        else
          all_adjectives[k] = v
        end
      end

      # extract_categories(str)
    end

    ap 'Analyzed ' + strings.count.to_s + ' requests'
    ap 'Nouns'
    ap Hash[all_nouns.sort_by{|k, v| v}.reverse]
    ap 'Adjectives'
    ap Hash[all_adjectives.sort_by{|k, v| v}.reverse]
  end

  desc 'Price Extraction'
  task :price => :environment do
    SIZE = 100
    prices = []
    Event.all.limit(SIZE).each do |e|
      price = e.description.scan(/\$\s*[\d.]+/)
      prices << price.first
      ap price.first.gsub!('$', '').gsub!('', '').to_i unless price.empty?
    end

    # ap prices
    ap "#{prices.count} / #{SIZE}"
  end

  #============================================================================
  # Advanced
  #============================================================================

  desc 'Category Extraction'
  task :pref => :environment do
    strings = []
    Conversation.order('RANDOM()').limit(30).each do |c|
      c.messages.each_with_index do |msg, index|
        # message before last includes date
        if (msg.body.include?("What sort of") || msg.body.include?("what type of")) && c.messages[index+1].present?
          if c.messages[index+1].inbound?
            strings << c.messages[index+1].body
          end
        end
      end
    end

    strings.each_with_index do |str, i|
      ap str
      extract_categories(str)
    end
  end

  def extract_categories(str)
    tgr = EngTagger.new
    str = normalize(str)

    tagged = tgr.add_tags(str.downcase)
    nouns = tgr.get_nouns(tagged)
    tags = []
    nouns.keys.each do |word|
      word = word.singularize
      tags << word if Tags::keyword?(word)
    end
    ap tags
  end

  def alchemy_extract(msg)
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"
    results = AlchemyAPI.search(:entity_extraction, text: msg)
    return nil if results.nil?
    results.each do |tag|
      if tag['type'] == 'Person'
        return tag['text']
      end
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