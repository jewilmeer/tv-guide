# == Schema Information
#
# Table name: episodes
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :text
#  path             :string(255)
#  nr               :integer
#  airdate          :date
#  downloaded       :boolean          default(FALSE)
#  watched          :boolean          default(FALSE)
#  season_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  nzb_file_name    :string(255)
#  nzb_content_type :string(255)
#  nzb_file_size    :integer
#  nzb_updated_at   :datetime
#  program_id       :integer
#  airs_at          :datetime
#  downloads        :integer          default(0)
#  season_nr        :integer
#  tvdb_id          :integer
#  program_name     :string(255)
#  tvdb_program_id  :integer
#  image_id         :integer
#

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
