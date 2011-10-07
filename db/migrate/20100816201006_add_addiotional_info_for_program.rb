class AddAddiotionalInfoForProgram < ActiveRecord::Migration
  def self.up
    add_column :programs, :overview, :text
    add_column :programs, :status, :string
    add_column :programs, :tvdb_id, :integer
    add_column :programs, :tvdb_last_update, :datetime
    add_column :programs, :imdb_id, :string
    add_column :programs, :airs_dayofweek, :string
    add_column :programs, :airs_time, :string
  end

  def self.down
    remove_column :programs, :airs_time
    remove_column :programs, :airs_dayofweek
    remove_column :programs, :imdb_id
    remove_column :programs, :tvdb_last_update
    remove_column :programs, :tvdb_id
    remove_column :programs, :status
    remove_column :programs, :overview
  end
end
