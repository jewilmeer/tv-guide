FactoryGirl.define do
  factory :episode do
    sequence(:title) {|n| "episode#{n}" }
    season_nr 1
    nr 1
    program
  end
end