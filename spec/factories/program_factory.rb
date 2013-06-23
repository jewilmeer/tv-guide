FactoryGirl.define do
  factory :program do
    sequence(:name) {|n| "program#{n}" }
    sequence(:tvdb_id) {|n| n }

    trait :indexed do
      status 'Continuing'
      airs_dayofweek 'Monday'
      airs_time '8:00 PM'
      runtime 60
    end
  end
end
