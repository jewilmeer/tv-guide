class AddSearchtermToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :search_term, :string
  end

  def self.down
    remove_column :programs, :search_term
  end
end
