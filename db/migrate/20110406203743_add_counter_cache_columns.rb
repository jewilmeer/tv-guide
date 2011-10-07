class AddCounterCacheColumns < ActiveRecord::Migration
  def self.up
    add_column :programs, :users_count, :integer, :default => 0
    add_column :programs, :interactions_count, :integer, :default => 0
    add_column :users, :programs_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :programs_count
    remove_column :programs, :interactions_count
    remove_column :programs, :users_count
  end
end