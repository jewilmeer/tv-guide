# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :program do |f|
    f.name 'House'
    f.status 'Continuing'
    f.airs_dayofweek 'Monday'
    f.airs_time '8:00 PM'
    f.runtime 60
  end
  
  factory :episode do
    f.title "MyString"
    f.description "MyText"
    f.path "MyString"
    f.filename "MyString"
    f.nr 1
    f.downloaded false
    f.watched ""
    f.season_id 1
  end
end
