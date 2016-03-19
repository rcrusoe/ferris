namespace :import do
  desc 'Import events from Facebook'
  task :facebook => :environment do
    RestClient.log = 'stdout'
    LIMIT = 5000
    EVENT_DATE_RANGE = 2.weeks
    FACEBOOK_URL = 'https://graph.facebook.com/search'
    APP_TOKEN = '1234616279893134|Eu-Wn_GvsmTTwJdO3prt61YSu1I'

    #============================================================================
    # Place
    #============================================================================
    PLACE_FIELDS = 'id,name,location,category,category_list,about,description,hours' +
                   'likes,checkins,price_range,cover.fields(source),picture.type(large),emails,phone,website,link'

    #============================================================================
    # Event
    #============================================================================
    EVENT_FIELDS = 'events.fields(id,name,link,description,ticket_uri,cover.fields(id,source),start_time,end_time,' +
                   'attending_count,maybe_count,interested_count)' +
                   '.since(' + Time.current.to_i.to_s + ').until(' + (Time.current + EVENT_DATE_RANGE).to_i.to_s + ')'

    #============================================================================
    # Categories
    #============================================================================
    CATEGORIES = ['concert']
                  # 'gallery',
                  # 'art',
                  # 'outdoors',
                  # 'sports',
                  # 'bars',
                  # 'restaurants',
                  # 'grill',
                  # 'music',
                  # 'concert venue']

    #============================================================================
    # Regions
    #============================================================================
    REGIONS = ['boston']
              # 'boston massachusetts',
              # 'cambridge massachusetts',
              # 'somerville massachusetts',
              # 'south end boston',
              # 'back bay boston']

    $places = []
    $events = []
    $places_with_events = 0
    puts 'Importing events from Facebook...'

    CATEGORIES.each do |category|
      REGIONS.each do |region|
        search("#{category} in #{region}")
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
      # skip place if already exists or has no events
      next if Place.where(fb_id: json['id']).present? || json['events'].nil?

      # sanitize and check for fields
      email = json['emails'].first if json.key?('emails')

      # default to cover photo, but fall back on picture
      if json.key?('cover')
        image = URI.parse(json['cover']['source'])
      elsif json.key?('picture')
        image = URI.parse(json['picture']['data']['url'])
      end

      # for now just concat location parameters into a string
      location = json['location']
      unless location.nil?
        address = [location['street'] || '', location['city'] || '', location['state'] || '', location['zip'] || ''].compact.join(', ')
      end

      place = Place.new(fb_id: json['id'],
                        name: json['name'],
                        about: json['about'],
                        description: json['description'],
                        fb_likes: json['likes'],
                        fb_checkins: json['checkins'],
                        fb_link: json['link'],
                        website: sanitize(json['website']),
                        email: sanitize(email),
                        phone_number: sanitize(json['phone']),
                        price_range: json['price_range'],
                        address: address,
                        approved: false)
                        # neighborhood: json['neighborhood'],
      # place.image = image
      # place.save
      $places << place
      # ap place

      # create events
      if json.key?('events')
        $places_with_events += 1

        json['events']['data'].each do |json_event|
          next if Event.where(fb_id: json_event['id']).present?

          # sanitize fields
          start_time = DateTime.strptime(json_event['start_time'],'%Y-%m-%dT%H:%M:%S').in_time_zone.to_time if json_event.key?('start_time')
          end_time = DateTime.strptime(json_event['end_time'],'%Y-%m-%dT%H:%M:%S').in_time_zone.to_time if json_event.key?('end_time')

          event = Event.new(fb_id: json_event['id'],
                            title: json_event['name'].downcase!.titleize,
                            description: json_event['description'],
                            short_blurb: json_event['description'],
                            website: "https://www.facebook.com/events/#{json_event['id']}",
                            purchase_url: json_event['ticket_uri'],
                            date: json_event['start_time'].to_date,
                            start_time: start_time,
                            end_time: end_time,
                            attending_count: json_event['attending_count'],
                            maybe_count: json_event['maybe_count'],
                            interested_count: json_event['interested_count'],
                            address: event.address,
                            approved: false)
          event.image = URI.parse(json_event['cover']['source']) if json_event.key?('cover')
          event.place = place
          event.save
          $events << event
          # ap event
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

  # catch facebooks nil case
  def sanitize(field)
    if field == '<<not-applicable>>'
      nil
    else
      field
    end
  end
end