class AddSortNrToEpisode < ActiveRecord::Migration
  def up
    add_column :episodes, :sort_nr, :integer

    remove_index :episodes, name: 'index_episodes_on_program_id_and_airs_at'
    remove_index :episodes, name: 'index_episodes_on_program_id_and_season_nr_and_nr'

    add_index :episodes, :sort_nr
    add_index :episodes, :program_id
    add_index :episodes, :airs_at

    Episode.update_all 'sort_nr = (season_nr * 1000)+nr'
  end
end
