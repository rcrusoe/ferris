# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "MyString"
    description "MyText"
    date "2015-12-13"
    start_time "2015-12-13 09:00:22"
    end_time "2015-12-13 09:00:22"
    address "MyString"
    website "MyString"
    price 1
    purchase_url "MyString"
  end
end
