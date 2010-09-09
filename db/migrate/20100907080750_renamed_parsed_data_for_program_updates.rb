class RenamedParsedDataForProgramUpdates < ActiveRecord::Migration
  def self.up
    rename_column :program_updates, :parsed_text, :parsed_data
  end

  def self.down
    rename_column :program_updates, :parsed_data, :parsed_text
  end
end
