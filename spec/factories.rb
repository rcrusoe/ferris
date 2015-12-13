FactoryGirl.define do
  factory :event do
    title     "Sample Event"
    description    "It's something to do. Stop complaining about specifics."
    date "Friday, December 13th"
    start_time "8:00am"
    end_time "1:00pm"
    address "5 Riverside Place, Cambridge, MA 02139"
    website "www.greig.io"
    price "5"
  end
end