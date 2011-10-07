class ChangeDataModelOfPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :tvdb_name, :string
    rename_column :programs, :search_term, :search_name
  end

  def self.down
    rename_column :programs, :search_name, :search_term
    remove_column :programs, :tvdb_name
  end
end