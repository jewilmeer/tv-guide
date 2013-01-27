# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  url                :string(255)
#  image_type         :string(255)
#  downloaded         :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :image do
    sequence(:url) {|n| 'placehold.it/10x#{10*n}' }
  end

  factory :episode_image, :parent => :image do
    episode
  end
end
