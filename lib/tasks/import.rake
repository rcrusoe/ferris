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
    PLACE_FIELDS = 'id,name,location,category,category_list,about,description,hours,' +
                   'likes,checkins,price_range,cover.fields(source),picture.type(large),emails,phone,website,link'

    #============================================================================
    # Event
    #============================================================================
    EVENT_FIELDS = 'events.fields(id,name,link,description,ticket_uri,cover.fields(id,source),start_time,end_time,' +
                   'attending_count,maybe_count,interested_count,place)' +
                   '.since(' + Time.current.to_i.to_s + ').until(' + (Time.current + EVENT_DATE_RANGE).to_i.to_s + ')'

    #============================================================================
    # Categories
    #============================================================================
    CATEGORIES = ['concert', 'concert venue', 'music', 'festival', 'theater', 'comedy', 'jazz', 'hip hop',
                  # 'gallery', 'museum', 'art', 'art gallery', 'books',
                  # 'outdoors', 'sports', 'bicycle', 'bike', 'swim', 'sail', 'kayak', 'running', 'rock climbing',
                  # 'nightlife', 'bars', 'drinks', 'food', 'club', 'dance', 'party',
                  # 'science', 'technology', 'trivia',
                  # 'restaurants', 'grill', 'coffee', 'cafe',
                  # 'college', 'university'
                 ]

    #============================================================================
    # Regions
    #============================================================================
    REGIONS = ['boston',
               # 'boston massachusetts',
               # 'cambridge massachusetts',
               # 'somerville massachusetts',
               # 'brookline massachusetts',
               # 'allston massachusetts',
               # 'south boston massachusetts',
               # 'jamaica plain massachusetts'
              ]

    $places = []
    $events = []
    puts 'Importing events from Facebook...'
    started_at = Time.now

    CATEGORIES.each do |category|
      REGIONS.each do |region|
        puts "Query: #{category} in #{region}"
        search("#{category} in #{region}")
      end
    end

    # Output results
    puts "#{$places.count} places imported"
    puts "#{$events.count} events imported"
    puts "#{((Time.now - started_at)/60).to_i} minutes elapsed, queried #{CATEGORIES.count} keywords"
  end

  def search(query)
    url = FACEBOOK_URL+"?q=#{query}&type=page&fields=#{PLACE_FIELDS},#{EVENT_FIELDS}&limit=#{LIMIT}&access_token=#{APP_TOKEN}"

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

      next if skip_place?(json)

      # if place does not exist in DB, create before pulling events
      place = Place.where(fb_id: json['id']).first
      if place.nil?
        # sanitize and check for fields
        email = json['emails'].first if json.key?('emails')

        # default to cover photo, but fall back on picture
        if json.key?('cover')
          image = URI.parse(json['cover']['source'])
        elsif json.key?('picture')
          image = URI.parse(json['picture']['data']['url'])
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
                          approved: false)
        # neighborhood: json['neighborhood'],
        place.image = image
        place.save
        $places << place
        ap place

        # create a location for the place
        location = json['location']
        unless location.nil?
          loc = Location.create(place: place,
                          lat: location['latitude'],
                          lng: location['longitude'],
                          street: location['street'],
                          city: location['city'],
                          state: location['state'],
                          zip: location['zip'],
                          country: location['country'])
          ap loc
        end

        # tag place with categories
        if json.key?('category_list')
          json['category_list'].each do |category|
            tag = Tag.where(name: category['name'].downcase).first_or_create
            place.tags << tag
            place.save
          end
        end

        # create open hours
        if json.key?('hours')
          hours = json['hours']
          day_prefix = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
          day_prefix.each_with_index do |day, index|
            OpenTime.create(place: place, day: index, open_time: hours["#{day}_1_open"], close_time: hours["#{day}_1_close"]) if hours.key?("#{day}_1_open")
          end
        end
      end

      # add any new events for place
      if json.key?('events')
        json['events']['data'].each do |json_event|
          next if Event.where(fb_id: json_event['id']).present?

          # sanitize fields
          start_time = DateTime.strptime(json_event['start_time'],'%Y-%m-%dT%H:%M:%S').in_time_zone.to_time if json_event.key?('start_time')
          end_time = DateTime.strptime(json_event['end_time'],'%Y-%m-%dT%H:%M:%S').in_time_zone.to_time if json_event.key?('end_time')

          event = Event.new(fb_id: json_event['id'],
                            title: json_event['name'].downcase.titleize,
                            description: json_event['description'],
                            short_blurb: json_event['description'],
                            website: "https://www.facebook.com/events/#{json_event['id']}",
                            purchase_url: json_event['ticket_uri'],
                            date: start_time.to_date,
                            start_time: start_time,
                            end_time: end_time,
                            attending_count: json_event['attending_count'],
                            maybe_count: json_event['maybe_count'],
                            interested_count: json_event['interested_count'],
                            address: place.address,
                            price: extract_price(json_event['description']),
                            approved: false)
          event.image = URI.parse(json_event['cover']['source']) if json_event.key?('cover')
          event.place = place
          event.save
          $events << event
          ap event
        end
      end
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

  # returns true if import should skip given place
  def skip_place?(json)
    if json['events'].nil?
      return true
    end

    if json.key?('location')
      if json['location']['state'] != 'MA'
        return true
      end

      # if ['boston', 'cambridge', 'somerville', 'brookline', 'allston', 'brighton'].include?(json['location']['city'].downcase)
      #   return true
      # end
    end

    return false
  end

  # get price from description
  def extract_price(string)

  end
end