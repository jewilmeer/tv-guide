class AddStationTable < ActiveRecord::Migration
  def up
    create_table :stations do |t|
      t.string :name, null: false
      t.integer :user_id
      t.integer :taggable_id
      t.string :taggable_type
    end
  end

  def down
    drop_table :stations
  end
end
