class StationProgram < ActiveRecord::Base
  self.table_name= 'programs_stations'
  belongs_to :station
  belongs_to :program

  validates :program_id, uniqueness: { scope: :station_id }

  before_create ->(sp) { sp.initially_followed?; true }
  after_create ->(sp) {
    return true unless sp.initially_followed?
    program.delay.tvdb_update_banners
    sp.delay.schedule_downloads
  }
  before_save -> { self.station.touch }

  def schedule_downloads
    self.program.episodes.map{|episode| episode.delay.download }
  end

  def initially_followed?
    @initially_followed = self.class.where(program_id: self.program_id).any?
  end
end

# == Schema Information
#
# Table name: programs_stations
#
#  id         :integer          not null, primary key
#  station_id :integer
#  program_id :integer
#

