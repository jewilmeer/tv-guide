require 'spec_helper'

describe Program do
  describe "#update name" do
    let(:episode) { create :episode, program: program }
    let(:program) { create(:program) }

    it "also updates the program name of associated episodes" do
      expect{ program.update_attribute(:name, 'changed') }.to \
        change(episode, :program_name)
    end

    it "does not update the episode if the name is unchanged" do
      expect{ program.update_attribute(:max_season_nr, 99) }.not_to \
        change(episode, :program_name)
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
#  program_preferences_count :integer          default(0)
#

