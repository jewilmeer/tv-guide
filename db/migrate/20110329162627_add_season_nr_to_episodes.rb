class AddSeasonNrToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :season_nr, :integer
  end

  def self.down
    remove_column :episodes, :season_nr
  end
end
