desc 'This task is called by the Heroku scheduler add-on'
task :schedule_events => :environment do
  WEEKS_TO_GENERATE = 2
  puts 'Generating recurring events...'
  events = Event.where(repeat_weekly: true).where(date: Date.today)
  events.each do |event|
    WEEKS_TO_GENERATE.times do |n|
      next_week = event.dup
      next_week.date += (n + 1).week
      next_week.save
    end
  end
  puts "#{events.count} events repeated"
end