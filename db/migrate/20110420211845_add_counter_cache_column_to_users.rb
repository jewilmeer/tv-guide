class AddCounterCacheColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :interactions_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :interactions_count
  end
end