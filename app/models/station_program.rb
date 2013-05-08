class StationProgram < ActiveRecord::Base
  set_table_name 'programs_stations'
  belongs_to :station
  belongs_to :program

  validates :program_id, uniqueness: { scope: :station_id }
end

# == Schema Information
#
# Table name: programs_stations
#
#  id         :integer          not null, primary key
#  station_id :integer
#  program_id :integer
#

