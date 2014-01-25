class AddForeignKeyIndexesBack < ActiveRecord::Migration
  def change
    add_index :downloads, :episode_id
    add_index :episodes, :program_id
    add_index :stations, :user_id
    add_index :programs_stations, :program_id
    add_index :programs_stations, :station_id
  end
end
