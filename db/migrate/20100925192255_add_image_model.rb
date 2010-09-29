class AddImageModel < ActiveRecord::Migration
  def self.up
    create_table(:images) do |t|
      t.string    :image_file_name
      t.string    :image_content_type, :string
      t.integer   :image_file_size
      t.datetime  :image_updated_at
      t.timestamps
    end
    
    create_table :images_programs, :id => false do |t|
      t.integer :image_id
      t.integer :program_id
    end
    add_index :images_programs, [:program_id, :image_id], :uniq => true
    
    add_column :episodes, :downloads, :integer, :default => 0
  end

  def self.down
    drop_table :images
    remove_index :images_programs, [:program_id, :image_id]
    drop_table :images_programs
    remove_column :episodes, :downloads
  end
end
