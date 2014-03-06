class Station::ProgramsController < Station::BaseController
  respond_to :html, :js

  def new
    @station = find_station
    @station_program = @station.station_programs.build
  end

  def create
    @program = find_program
    @station = find_station
    @station_program = @station.station_programs.create program: @program
    redirect_to :back
  end

  def destroy
    station = current_user.stations.friendly.find params[:station_id]
    program = Program.friendly.find params[:id]
    station.programs.delete program
    redirect_to :back
  end


  def find_program
    if params[:id]
      Program.friendly.find params[:id]
    else
      Program.find params[:station_program][:program_id]
    end
  end
end