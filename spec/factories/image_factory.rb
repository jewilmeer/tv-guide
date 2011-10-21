FactoryGirl.define do
  factory :image do
    sequence(:url) {|n| 'placehold.it/10x#{10*n}' }
  end

  factory :episode_image, :parent => :image do
    episode
  end
end