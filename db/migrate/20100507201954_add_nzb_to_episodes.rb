class AddNzbToEpisodes < ActiveRecord::Migration
  def self.up
    remove_column :episodes, :filename
    add_column :episodes, :nzb_file_name,    :string
    add_column :episodes, :nzb_content_type, :string
    add_column :episodes, :nzb_file_size,    :integer
    add_column :episodes, :nzb_updated_at,   :datetime
  end

  def self.down
    # add_column :episodes, :filename, :string
    remove_column :episodes, :nzb_file_name
    remove_column :episodes, :nzb_content_type
    remove_column :episodes, :nzb_file_size
    remove_column :episodes, :nzb_updated_at
  end
end
