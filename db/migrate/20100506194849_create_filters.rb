class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.integer :program_id
      t.boolean :active, :default => true
      t.text :filter_data
      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
