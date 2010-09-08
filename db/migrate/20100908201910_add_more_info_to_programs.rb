class AddMoreInfoToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :runtime, :integer
    add_column :programs, :genres, :string
    add_column :programs, :network, :string
    add_column :programs, :contentrating, :string
    add_column :programs, :actors, :text
    add_column :programs, :tvdb_rating, :integer
  end

  def self.down
    renive_column :programs, :runtime
    renive_column :programs, :genres
    renive_column :programs, :network
    renive_column :programs, :contentrating
    renive_column :programs, :actors
    renive_column :programs, :tvdb_rating
  end
end
