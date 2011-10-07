class RemoveMigrationsFromProgram < ActiveRecord::Migration
  def self.up
    remove_column :programs, :genres
  end

  def self.down
    add_column :programs, :genres, :string
  end
end
