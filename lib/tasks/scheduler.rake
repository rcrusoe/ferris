desc 'This task is called by the Heroku scheduler add-on nightly, but only executes once a month'
task :schedule_events => :environment do
  count = 0
  if Date.current == Date.current.end_of_month
    Event.where.not(recurrence: nil).each do |event|
      schedule = IceCube::Schedule.new
      schedule.add_recurrence_rule(event.recurrence)
      # schedule events for the next month if they do not already exist
      schedule.occurrences(Time.current + 1.month).each do |o|
        Occurrence.where(event: event, date: o.to_date).first_or_create do |occurrence|
          count += 1
          ap occurrence
        end
      end
    end
    puts "#{count} event occurrences generated for #{Date.current..Date.current + 1.month}"
  end
end