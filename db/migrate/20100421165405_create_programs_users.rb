class CreateProgramsUsers < ActiveRecord::Migration
  def self.up
    create_table :programs_users, :id => false do |t|
      t.integer :program_id
      t.integer :user_id
    end
    add_index :programs_users, [:program_id, :user_id], :uniq => true
    add_index :programs_users, [:user_id, :program_id], :uniq => true
  end

  def self.down
    drop_table :programs_users
    remove_index :programs_users, :column => [:program_id, :user_id]
    remove_index :programs_users, :column => [:user_id, :program_id]
  end
end
