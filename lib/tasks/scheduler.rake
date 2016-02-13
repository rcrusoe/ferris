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
      if Event.where(title: future_event.title, date: future_event.date).count == 0
        future_event.save
        future_event.copy_attachments_from(event) # custom patch for copying S3 bucket images
      end
    end
  end
  puts "#{events.count} events repeated"
end