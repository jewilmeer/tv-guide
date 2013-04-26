class AddIdexesToEpisodesTable < ActiveRecord::Migration
  def change
    add_index :episodes, [:program_id, :season_nr, :nr]
    add_index :episodes, [:program_id, :airs_at]
  end
end
