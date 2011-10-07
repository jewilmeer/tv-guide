class AddInteractionsTable < ActiveRecord::Migration
  def self.up
    create_table :interactions, :force => true do |t|
      t.integer :user_id
      t.integer :episode_id
      t.integer :program_id
      t.string :format, :default => 'nzb'
      t.string :interaction_type
      t.string :end_point
      t.timestamps
    end
  end

  def self.down
    drop_table :interactions
  end
end
