FactoryGirl.define do
  factory :program do
    sequence(:name) {|n| "program#{n}" }
    sequence(:tvdb_id) {|n| n }

    trait :indexed do
      status 'Continuing'
      airs_dayofweek 'Monday'
      airs_time '8:00 PM'
      runtime 60
    end
  end
end

# == Schema Information
#
# Table name: programs
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  search_name               :string(255)
#  overview                  :text
#  status                    :string(255)
#  tvdb_id                   :integer
#  tvdb_last_update          :datetime
#  imdb_id                   :string(255)
#  airs_dayofweek            :string(255)
#  airs_time                 :string(255)
#  runtime                   :integer
#  network                   :string(255)
#  contentrating             :string(255)
#  actors                    :text
#  tvdb_rating               :integer
#  last_checked_at           :datetime
#  time_zone_offset          :string(255)      default("Central Time (US & Canada)")
#  max_season_nr             :integer          default(1)
#  current_season_nr         :integer          default(1)
#  tvdb_name                 :string(255)
#  fanart_image_id           :integer
#  poster_image_id           :integer
#  season_image_id           :integer
#  series_image_id           :integer
#  program_preferences_count :integer          default(0)
#  interactions_count        :integer          default(0)
#

