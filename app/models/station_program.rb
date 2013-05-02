class StationProgram < ActiveRecord::Base
  set_table_name 'programs_stations'
  belongs_to :station
  belongs_to :program

  validates :program_id, uniqueness: { scope: :station_id }
end