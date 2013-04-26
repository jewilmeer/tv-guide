class AddIndexForDownloadsAndEpisodes < ActiveRecord::Migration
  def up
    add_index :downloads, :episode_id
    add_index :programs_stations, :program_id
    add_index :programs_stations, :station_id
    add_index :stations, :taggable_type
    add_index :stations, :user_id
  end

  def down
    remove_index :stations, :user_id
    remove_index :stations, :taggable_type
    remove_index :programs_stations, :station_id
    remove_index :programs_stations, :program_id
    remove_index :downloads, :episode_id
  end
end