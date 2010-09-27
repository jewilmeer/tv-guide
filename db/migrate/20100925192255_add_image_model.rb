class AddImageModel < ActiveRecord::Migration
  def self.up
    create_table(:images) do |t|
      
    end
  end

  def self.down
    drop_table(:images)
  end
end
