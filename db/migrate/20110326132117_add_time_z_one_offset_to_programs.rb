class AddTimeZOneOffsetToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :time_zone_offset, :string, :default => 'Central Time (US & Canada)'
  end

  def self.down
    remove_column :programs, :time_zone_offset
  end
end