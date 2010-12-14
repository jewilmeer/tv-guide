class CreateDownloadsTable < ActiveRecord::Migration
  def self.up
    create_table :downloads, :force => true do |t|
      t.integer :episode_id
      t.string :download_type
      t.string :download_file_name
      t.string :download_content_type
      t.integer :download_file_size
      t.string :origin
      t.string :site
      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end
