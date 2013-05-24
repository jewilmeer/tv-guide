FactoryGirl.define do
  factory :image do
    sequence(:url) {|n| 'placehold.it/10x#{10*n}' }
  end

  factory :episode_image, :parent => :image do
    episode
  end
end

# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  source_url :string(255)
#  downloaded :boolean          default(FALSE)
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

