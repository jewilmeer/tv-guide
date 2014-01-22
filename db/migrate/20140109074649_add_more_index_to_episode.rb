class AddMoreIndexToEpisode < ActiveRecord::Migration
  def change
    add_index :episodes, :airdate
    add_index :episodes, :updated_at
  end
end
