class AddMoreInfoForEpisode < ActiveRecord::Migration
  def self.up
    add_column :episodes, :tvdb_id, :integer
    add_column :episodes, :program_name, :string
    add_column :episodes, :tvdb_program_id, :integer
  end

  def self.down
    remove_column :episodes, :tvdb_program_id
    remove_column :episodes, :program_name
    remove_column :episodes, :tvdb_id
  end
end