class AddIdexesToEpisodesTable < ActiveRecord::Migration
  def up
    add_index :episodes, [:program_id, :season_nr, :nr]
    add_index :episodes, [:program_id, :airs_at]
  end
end
