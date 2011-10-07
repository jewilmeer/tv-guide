class AddLastCheckedAtToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :last_checked_at, :datetime
  end

  def self.down
    remove_column :programs, :last_checked_at
  end
end
