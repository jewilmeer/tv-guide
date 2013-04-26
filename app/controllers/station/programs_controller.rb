class Station::ProgramsController < Station::BaseController
  def new
    @station = find_station
    @station_program = @station.station_programs.build
  end

  def create
    @program = Program.find_by_name(params[:station_program][:program_id])
    @station = find_station
    @station_program = @station.station_programs.create program: @program
    redirect_to user_programs_path(current_user), notice: 'Kanaries'
  end
end