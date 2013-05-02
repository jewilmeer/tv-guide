class Station::ProgramsController < Station::BaseController
  respond_to :html, :js

  def new
    @station = find_station
    @station_program = @station.station_programs.build
  end

  def create
    @program = Program.find_by_name(params[:station_program][:program_id])
    @station = find_station
    @station_program = @station.station_programs.create program: @program
    respond_with @station_program, location: station_path(@station)
  end
end