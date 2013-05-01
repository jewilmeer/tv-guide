class StationProgram < ActiveRecord::Base
  self.table_name 'programs_stations'
  belongs_to :station
  belongs_to :program
end