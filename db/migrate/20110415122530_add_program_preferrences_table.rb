class AddProgramPreferrencesTable < ActiveRecord::Migration
  def self.up
    create_table :program_preferences, :force => true do |t|
      t.integer :user_id
      t.integer :program_id
      t.boolean :download, :default => true
      t.integer :search_term_type_id, :default => 1 #hd
      t.timestamps
    end
    
    create_table :search_term_types, :force => true do |t|
      t.string :name
      t.string :code
      t.string :search_term
      t.timestamps
    end
  end

  def self.down
    drop_table :search_term_types
    drop_table :program_preferences
  end
end