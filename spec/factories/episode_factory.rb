FactoryGirl.define do
  factory :episode do
    sequence(:title) { |n| "episode#{n}" }
    season_nr 1
    sequence(:nr) {|n| n }
    airs_at { Time.now }
    sequence(:tvdb_id) { |n| n*rand(10_000) }
    # associations
    program

    trait :with_download do
      after(:create) do |episode, factory_attributes|
        FactoryGirl.create_list :download, 2, episode: episode
      end
    end
  end
end

# == Schema Information
#
# Table name: episodes
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  nr           :integer
#  airdate      :date
#  created_at   :datetime
#  updated_at   :datetime
#  program_id   :integer
#  airs_at      :datetime
#  season_nr    :integer
#  tvdb_id      :integer
#  program_name :string(255)
#

