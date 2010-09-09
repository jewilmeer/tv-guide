class User::ProgramsController < UserAreaController
  def create
    if params[:id]
      current_user.programs << Program.find(params[:id])
    else
      @program = Program.find_or_create_by_name(params[:name])
      raise ActiveRecord::RecordNotFound unless @program
      current_user.programs << @program
    end
    respond_to do |format|
      format.html do
        flash[:notice] = 'Program added!'
        redirect_to :back
      end
      format.js {}
    end
  end
  
  def index
    @programs           = @user.programs
    @upcomming_episodes = Episode.airdate_inside(Date.today, 1.week.from_now).watched_by_user(@user.programs).by_airdate(:desc)
    @past_episodes      = Episode.airdate_inside(1.week.ago, Date.today).watched_by_user(@user.programs).by_airdate(:desc)
  end
  
  def destroy
    current_user.programs.delete(Program.find(params[:id]))
    flash[:notice] = 'Program removed'
    redirect_to :back
  end
end