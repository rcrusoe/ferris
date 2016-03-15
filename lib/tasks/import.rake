namespace :import do
  desc 'Import events from Facebook'
  task :facebook => :environment do
    # RestClient.log = 'stdout'
    FACEBOOK_URL = 'https://graph.facebook.com/search'
    RAW_URL = 'https://graph.facebook.com/search?type=place&q=*&center=$DELIM$&distance=2000&limit=1000&access_token=1234616279893134|Eu-Wn_GvsmTTwJdO3prt61YSu1I'
    APP_TOKEN = '1234616279893134|Eu-Wn_GvsmTTwJdO3prt61YSu1I'
    # LOCATIONS = [[42.359819, -71.060094]]#, [42.347637, -71.073658], [42.367231, -71.098330]]
    # DISTANCE = 1000

    CATEGORIES = ['art', 'history', 'music', 'concert venues', 'sports', 'bars', 'restaurants', 'grill', 'gallery']
    PLACES = ['boston', 'boston massachusetts', 'cambridge massachusetts', 'somerville massachusetts', 'south end boston', 'back bay boston']
    places_with_events = 0
    events_count = 0
    puts 'Importing events from Facebook...'

    LOCATIONS.each do |loc|
      places = get_places_for_loc(loc)
      puts "#{places.count} places found"
      # create batches of 50 place IDs to bulk query
      ids = places.map { |p| p['id'] }.each_slice(50).to_a

      # for each slice of 50 ids, get all place and event data
      all_events = []
      ids.each do |id_slice|
        url = 'https://graph.facebook.com/v2.5/?ids=' + id_slice.join(',').to_s + '&fields=name,description,hours,likes,checkins,cover.fields(id,source),'\
            'picture.type(large),location,events.fields(id,name,cover.fields(id,source),picture.type(large),description,start_time,attending_count,'\
            'declined_count,maybe_count,noreply_count).since(' + Time.current.to_i.to_s + ').until(' + (Time.current + 1.month).to_i.to_s + ')&access_token=1234616279893134|Eu-Wn_GvsmTTwJdO3prt61YSu1I'
        response = RestClient.get url, {:accept => :json}
        JSON(response).map { |p| p[1] }.each do |place|
          if place.key?('events')
            places_with_events += 1
            ap place
          end
        end
      end

      ap places_with_events
    end
  end

  # returns a JSON conversation list from front
  def get_places_for_loc(loc)
    all_locations = []
    finished = false
    url = RAW_URL
    url.gsub!('$DELIM$', "#{loc[0]}, #{loc[1]}")

    until finished do
      response = RestClient.get url, {:accept => :json}
      json = JSON(response)
      all_locations << json['data']
      if json['paging'].key?('next')
        url = json['paging']['next']
      else
        finished = true
      end
    end

    all_locations.flatten!
  end
end