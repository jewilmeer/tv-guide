FactoryGirl.define do
  factory :episode do
    sequence(:title) {|n| "episode#{n}" }
    season_nr 1
    sequence(:nr) {|n| n }
    program
    airs_at { Time.now }
    trait :with_download do
      after(:create) do |episode, factory_attributes|
        FactoryGirl.create_list :download, 2, episode: episode
      end
    end
  end
end