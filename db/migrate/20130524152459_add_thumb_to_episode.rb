class AddThumbToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :thumb, :string
  end
end
