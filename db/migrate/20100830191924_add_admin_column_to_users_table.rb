class AddAdminColumnToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :trusted, :boolean, :default => false
  end

  def self.down
    remove_column :users, :trusted
    remove_column :users, :admin
  end
end
