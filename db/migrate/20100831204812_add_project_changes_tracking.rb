class AddProjectChangesTracking < ActiveRecord::Migration
  def self.up
    create_table :program_updates, :force => true do |t|
      t.integer :program_id
      t.text :revision_data
      t.text :parsed_text
      t.timestamps
    end
  end

  def self.down
    drop_table :program_updates
  end
end
