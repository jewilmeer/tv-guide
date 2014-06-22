FactoryGirl.define do
  factory :episode do
    sequence(:title) { |n| "episode#{n}" }
    season_nr 1
    sequence(:nr) {|n| n }
    airs_at { Time.now }
    sequence(:tvdb_id) { |n| n*rand(10_000) }
    # associations
    program
  end
end
