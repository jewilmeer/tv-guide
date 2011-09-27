# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :program do
    name 'House'
    status 'Continuing'
    airs_dayofweek 'Monday'
    airs_time '8:00 PM'
    runtime 60
    fetch_remote_information false
  end
  
  factory :episode do
    title "MyString"
    season_nr 1
    nr 1
    program
  end
end
