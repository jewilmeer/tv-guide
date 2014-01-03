# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :network do
    sequence(:name) {|n| "Network #{n}" }
  end
end
