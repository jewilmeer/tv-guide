class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.string :title
      t.text :description
      t.string :path
      t.string :filename
      t.integer :nr
      t.date :airdate
      t.boolean :downloaded, :default => false
      t.boolean :watched, :default => false
      t.integer :season_id

      t.timestamps
    end
    
    add_index :episodes, [:season_id, :nr], :name => "chained_index"
  end

  def self.down
    drop_table :episodes
    remove_index :chained_index
  end
end
