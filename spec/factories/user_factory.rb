FactoryGirl.define do
  factory :user do
    sequence(:login) {|n| "user#{n}" }
    email { "#{login}@example.com" }
    password "secret"
    password_confirmation { password }
  end
end