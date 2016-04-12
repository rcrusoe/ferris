namespace :refactor do
  desc 'get all events with a repeat_weekly flag and create occurrences'
  task :recurrence => :environment do
    Event.all.each do |event|
      if event.repeat_weekly?
        # schedule events for the next month
        event.recurrence = IceCube::Rule.weekly.day(event.date.wday)
        schedule = IceCube::Schedule.new
        schedule.add_recurrence_rule(event.recurrence)
        schedule.occurrences(Time.current + 1.month).each do |o|
          Occurrence.create(event: event, date: o.to_date)
        end
        event.save
      else
        Occurrence.create(event: event, date: event.date)
      end
    end
  end

  desc 'get all venue time properties and put in open_time table'
  task :open_time_migration => :environment do
    i = 0
    Place.all.each do |place|
      OpenTime.create(place: place, day: 1, open_time: place.monday_open_time, close_time: place.monday_close_time) if place.monday_open?
      OpenTime.create(place: place, day: 2, open_time: place.tuesday_open_time, close_time: place.tuesday_close_time) if place.tuesday_open?
      OpenTime.create(place: place, day: 3, open_time: place.wednesday_open_time, close_time: place.wednesday_close_time) if place.wednesday_open?
      OpenTime.create(place: place, day: 4, open_time: place.thursday_open_time, close_time: place.thursday_close_time) if place.thursday_open?
      OpenTime.create(place: place, day: 5, open_time: place.friday_open_time, close_time: place.friday_close_time) if place.friday_open?
      OpenTime.create(place: place, day: 6, open_time: place.saturday_open_time, close_time: place.saturday_close_time) if place.saturday_open?
      OpenTime.create(place: place, day: 0, open_time: place.sunday_open_time, close_time: place.sunday_close_time) if place.sunday_open?
      i += 1
      puts "Business Hours Migrated for #{place.name}"
    end
    puts "Done, #{i} places updated."
  end

  desc 'take address fields off places and events, reverse_geocode and save'
  task :location => :environment do
    # for each place, take the address string and create location fields
    places = Place.where(approved: true)
    places.to_a.each do |p|
      geo = Geocoder.search(p.address).first
      puts 'querying...'
      sleep(2)
      p.street = geo.street_address
      p.city = geo.city
      p.state = geo.state_code
      p.zip = geo.postal_code
      p.country = geo.country
      p.neighborhood = geo.neighborhood
      p.lat = geo.coordinates[0]
      p.lng = geo.coordinates[1]
      p.save
      ap p
    end
  end

  desc 'retag music venues with foursquare categories'
  task :categorize => :environment do
    # get all venue info
    # extract phone number, stats, url, rating, description, listed? (for lists that contain the venue), tips
    # tags, photos, phrases, attributes

    music_venues = Place.joins(:tags).where('tags.name ILIKE ?', '%concert%').uniq

    music_venues.each_with_index do |place, i|
      unless place.lat.nil?
        ap place.name + ' located in ' + place.lat.to_s + ', ' + place.lng.to_s

        # for each place, query foursquare with lat/lng + name
        results = client.search_venues({ll:"#{place.lat}, #{place.lng}", query: place.name, limit:'1'})

        unless results['venues'].empty?
          venue = client.venue(results['venues'].first['id'])

          ap venue['name']
          ap results['venues'].first['categories'].map {|c| [c['name'], c['primary']] }
        end
      end
    end
  end
end