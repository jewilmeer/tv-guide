class ImproveIdexesForProgramsAndEpisodes < ActiveRecord::Migration
  def up
    remove_index :downloads, :episode_id
    remove_index :episodes, :program_id
    remove_index :stations, :user_id
    remove_index :programs_stations, :program_id
    remove_index :programs_stations, :station_id

    add_foreign_key :downloads, :episodes, dependent: :delete
    add_foreign_key :episodes, :programs, dependent: :delete
    add_foreign_key :genres_programs, :genres
    add_foreign_key :genres_programs, :programs
    add_foreign_key :images, :programs, dependent: :delete
    add_foreign_key :interactions, :users, dependent: :delete
    add_foreign_key :interactions, :programs, dependent: :delete
    add_foreign_key :interactions, :episodes, dependent: :delete
    add_foreign_key :programs_stations, :programs
    add_foreign_key :programs_stations, :stations
    add_foreign_key :stations, :users, dependent: :delete
  end

  def down

  end
end
