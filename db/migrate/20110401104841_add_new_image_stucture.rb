class AddNewImageStucture < ActiveRecord::Migration
  def self.up
    add_column :images, :url, :string
    add_column :images, :image_type, :string
    add_column :images, :downloaded, :boolean, :default => false
    remove_column :images, :string
  end

  def self.down
    add_column :images, :string, :string
    remove_column :images, :image_type
    remove_column :images, :downloaded
    remove_column :images, :url
  end
end
