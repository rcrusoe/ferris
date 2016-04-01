namespace :bot do
  # https://github.com/louismullie/treat
  #============================================================================
  # Basic
  #============================================================================
  desc 'Named Entity Recognition'
  task :who => :environment do
    ap ChatManager.hello
  end

  desc 'Date Recognition'
  task :when => :environment do
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"

    strings = []
    Conversation.all.order('created_at desc').each do |c|
      c.messages.each_with_index do |msg, index|
        # message before last includes date
        strings << c.messages[index-1].body if msg.body.include? "Sure! There's so many great options"
      end
    end

    dates = []
    strings.each do |s|
      ap s
      s.gsub!('!', '')
      s.gsub!('?', '') if s.chars.count > 1
      s.gsub!('/', ' ')
      # ap s
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

      unless parsed.nil?
        dates << parsed
        ap parsed
      end
      # ap s if parsed.nil?
    end
    puts "#{dates.count} / #{strings.count}"
  end

  desc 'Category Extraction'
  task :what => :environment do
    puts 'What would you like to do?'
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

  desc 'Create a mapping of what users do and do not like, across every conversation'
  task :preferences => :environment do
    puts 'What kind of things do you like?'
  end
end

private

def extract_date_msg(conversation)
  last_msg = nil

end