FactoryGirl.define do
  factory :program do
    sequence(:name) {|n| "program#{n}" }
    status 'Continuing'
    airs_dayofweek 'Monday'
    airs_time '8:00 PM'
    runtime 60
    fetch_remote_information false
  end
end