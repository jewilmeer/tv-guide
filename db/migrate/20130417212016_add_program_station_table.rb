class AddProgramStationTable < ActiveRecord::Migration
  def up
    create_table :programs_stations do |t|
      t.references :station
      t.references :program
    end
  end

  def down
    drop_table :programs_stations
  end
end
