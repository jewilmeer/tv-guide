class AddImageToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :image_id, :integer
  end

  def self.down
    remove_column :episodes, :image_id
  end
end