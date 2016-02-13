desc 'This task is called by the Heroku scheduler add-on'
task :schedule_events => :environment do
  WEEKS_TO_GENERATE = 2
  puts 'Generating recurring events...'
  events = Event.where(repeat_weekly: true, date: Date.today)
  events.each do |event|
    WEEKS_TO_GENERATE.times do |n|
      future_event = event.dup
      future_event.date += (n + 1).week
      # only save the event for the next week if it does not already exist
      future_event.save if Event.where(title: future_event.title, date: future_event.date).count == 0
    end
  end
  puts "#{events.count} events repeated"
end