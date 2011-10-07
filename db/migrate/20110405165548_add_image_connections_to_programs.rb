class AddImageConnectionsToPrograms < ActiveRecord::Migration
  def self.up
    remove_column :programs, :banner_file_name
    remove_column :programs, :banner_content_type
    remove_column :programs, :banner_file_size
    remove_column :programs, :banner_updated_at
    add_column :programs, :fanart_image_id, :integer
    add_column :programs, :poster_image_id, :integer
    add_column :programs, :season_image_id, :integer
    add_column :programs, :series_image_id, :integer
  end

  def self.down
    remove_column :programs, :series_image_id
    remove_column :programs, :season_image_id
    remove_column :programs, :poster_image_id
    remove_column :programs, :fanart_image_id
    add_column :programs, :banner_updated_at, :datetime
    add_column :programs, :banner_file_size, :integer
    add_column :programs, :banner_content_type, :string
    add_column :programs, :banner_file_name, :string
  end
end