namespace :import do
  desc 'Import events from Facebook'
  task :facebook => :environment do
    RestClient.log = 'stdout'
    LIMIT = 5
    EVENT_DATE_RANGE = 1.month
    FACEBOOK_URL = 'https://graph.facebook.com/search'
    APP_TOKEN = '1234616279893134|Eu-Wn_GvsmTTwJdO3prt61YSu1I'
    # MAYBE_ADD_LATER = 'picture.type(large),talking_about_count,ratings(NEED_PAGE_ACCESS_TOKEN)'
    PLACE_FIELDS = 'id,name,link,category,category_list,about,description,likes,checkins,location,hours,price_range,cover.fields(source),emails,phone,website'
    EVENT_FIELDS = 'events.fields(id,name,category,description,ticket_uri,cover.fields(id,source),start_time,attending_count,'\
            'declined_count,maybe_count,noreply_count).since(' + Time.current.to_i.to_s + ').until(' + (Time.current + EVENT_DATE_RANGE).to_i.to_s + ')'

    CATEGORIES = ['art gallery']
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

    # events.fields(id,name,cover.fields(id,source),picture.type(large),description,start_time,attending_count,'\
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

  def search(query)
    url = FACEBOOK_URL+"?q=#{query}&type=page&fields=#{PLACE_FIELDS},#{EVENT_FIELDS}&limit=#{LIMIT}&access_token=#{APP_TOKEN}"

    # loop over each page of responses
    loop do
      response = RestClient.get url, {accept: :json}
      json = JSON(response)
      # ap json
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
      # TODO: do we want to update places? if so don't skip, first_or_create
      next if Place.where(fb_id: json['id']).present?

      # processing on fields
      email = json['emails'].first if json.key?('emails')

      place = Place.new(fb_id: json['id'],
                        name: json['name'],
                        about: json['about'],
                        description: json['description'],
                        fb_likes: json['likes'],
                        fb_checkins: json['checkins'],
                        fb_link: json['link'],
                        website: json['website'],
                        email: email,
                        phone_number: json['phone'],
                        price_range: json['price_range'],
                        approved: false)
                        # address: json['address'],
                        # neighborhood: json['neighborhood'],
                        # phone_number: json['phone_number'])
      place.image = URI.parse(json['cover']['source']) if json.key?('cover')
      place.save
      $places << place
      # ap place

      # create events
      # if json.key?('events')
      #   $places_with_events += 1
      #   json['events']['data'].each do |json_event|
      #     event = Event.new(title: json_event['name'],
      #                       # description:,
      #                       date: json_event['start_time'].to_date,
      #                       start_time: json_event['start_time'].to_time.utc
      #                       # end_time:,
      #     )
      #     event.place = place
      #     # event.save
      #     $events << event
      #     # ap event
      #   end
      # end

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