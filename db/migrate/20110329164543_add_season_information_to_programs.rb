class AddSeasonInformationToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :max_season_nr, :integer, :default => 1
    add_column :programs, :current_season_nr, :integer, :default => 1
  end

  def self.down
    remove_column :programs, :current_season_nr
    remove_column :programs, :max_season_nr
  end
end