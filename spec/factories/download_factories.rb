FactoryGirl.define do
  factory :download do
    origin "Fancy download"
    site "google.com"
    # associations
    episode
  end
end