namespace :bot do
  # https://github.com/louismullie/treat
  #============================================================================
  # Basic
  #============================================================================
  desc 'Named Entity Recognition'
  task :who => :environment do
    puts 'When would you like to do something?'
  end

  desc 'Date Recognition'
  task :when => :environment do
    puts 'When would you like to do something?'
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