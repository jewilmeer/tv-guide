class AddAirdateToEpisode < ActiveRecord::Migration
  def self.up
    add_column :episodes, :airs_at, :datetime
  end

  def self.down
    remove_column :episodes, :airs_at
  end
end
