class User::ProgramsController < UserAreaController
  def create
    if params[:id]
      current_user.programs << Program.find(params[:id])
    else
      @program = Program.find_or_create_by_name(params[:name])
      raise ActiveRecord::RecordNotFound unless @program
      current_user.programs << @program
    end
    flash[:notice] = 'Program added!'
  end
  
  def index
    @programs           = @user.programs
    @upcomming_episodes = Episode.airdate_inside(1.week.ago, Date.today).watched_by_user(@user.programs).by_airdate(:desc)
  end
end