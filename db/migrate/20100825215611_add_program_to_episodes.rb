class AddProgramToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :program_id, :integer
  end

  def self.down
    remove_column :episodes, :program_id
  end
end
