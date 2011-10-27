FactoryGirl.define do
  factory :episode do
    sequence(:title) {|n| "episode#{n}" }
    season_nr 1
    sequence(:nr) {|n| n }
    program
  end
end