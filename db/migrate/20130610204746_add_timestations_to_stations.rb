class AddTimestationsToStations < ActiveRecord::Migration
  def change
    change_table :stations do |t|
      t.timestamps
    end
  end
end
