namespace :import do
  desc 'Import events from Facebook'
  task :facebook => :environment do
    RestClient.log = 'stdout'
    FACEBOOK_URL = 'https://graph.facebook.com/search'
    APP_TOKEN = '1234616279893134|Eu-Wn_GvsmTTwJdO3prt61YSu1I'

    CATEGORIES = ['gallery']
                  # 'history',
                  # 'art',
                  # 'concert venues',
                  # 'sports',
                  # 'bars',
                  # 'restaurants',
                  # 'grill',
                  # 'museums']

    PLACES = ['boston']
              # 'boston massachusetts',
              # 'cambridge massachusetts',
              # 'somerville massachusetts',
              # 'south end boston',
              # 'back bay boston']

    $places = []
    $events = []
    $places_with_events = 0
    puts 'Importing events from Facebook...'

    # url = 'https://graph.facebook.com/v2.5/?ids=' + id_slice.join(',').to_s + '&fields=name,description,hours,likes,checkins,cover.fields(id,source),'\
    #         'picture.type(large),location,events.fields(id,name,cover.fields(id,source),picture.type(large),description,start_time,attending_count,'\
    #         'declined_count,maybe_count,noreply_count).since(' + Time.current.to_i.to_s + ').until(' + (Time.current + 1.month).to_i.to_s + ')&access_token=1234616279893134|Eu-Wn_GvsmTTwJdO3prt61YSu1I'

    CATEGORIES.each do |category|
      PLACES.each do |place|
        search("#{category} in #{place}")
      end
    end

    # Output results
    puts "#{$places.count} places imported"
    puts "#{$places_with_events} places with events"
    puts "#{$events.count} events imported"
  end

  # returns a JSON conversation list from front
  def search(query)
    events_str = 'events.fields(id,name,category,description,ticket_uri,type,cover.fields(id,source),start_time,attending_count,'\
            'declined_count,maybe_count,noreply_count).since(' + Time.current.to_i.to_s + ').until(' + (Time.current + 1.month).to_i.to_s + ')'
    url = FACEBOOK_URL+"?q=#{query}&type=page&fields=id,category_list,name,link,description,likes,checkins,hours,#{events_str}&limit=500&access_token=#{APP_TOKEN}"

    # loop over each page of responses
    loop do
      response = RestClient.get url, {accept: :json}
      json = JSON(response)
      deserialize(json['data'])

      if json.key?('next')
        url = json['next']
      else
        break
      end
    end
  end

  # converts a list of facebook place data to ActiveRecord Models
  def deserialize(list)
    list.each do |json|
      # skip if place already exists
      next if Place.where(name: json['name']).present?
      place = Place.new(name: json['name'],
                        description: json['description'],
                        # address: json['address'],
                        # neighborhood: json['neighborhood'],
                        website: json['link'])
                        # phone_number: json['phone_number'])
      # place.image = json['cover']
      place.save
      $places << place
      ap place

      # create events
      if json.key?('events')
        $places_with_events += 1
        json['events']['data'].each do |json_event|
          event = Event.new(title: json_event['name'],
                            # description:,
                            date: json_event['start_time'].to_date,
                            start_time: json_event['start_time'].to_time.utc
                            # end_time:,
          )
          event.place = place
          # event.save
          $events << event
          ap event
        end
      end

      # create open hours
      # if json.key?('hours')
      #   @places_with_events += 1
      #   json['events']['data'].each do |json_event|
      #     event = Event.new('fields')
      #     event.place = place
      #     event.save
      #   end
      # end
    end
  end
end