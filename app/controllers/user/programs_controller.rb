class User::ProgramsController < UserAreaController
  before_filter :require_trust, :only => :aired
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
    basic_episodes      = Episode.watched_by_user(@user.programs)
    @upcomming_episodes = basic_episodes.by_airs_at.airs_at_after(Time.now).limit(6)
    @past_episodes      = basic_episodes.by_airs_at(:desc).airs_at_before(Time.now).limit(20)
  end

  def aired
    @episodes           = Episode.airs_at_in_past.nzb_file_name_present.by_airs_at(:desc).limit(30).includes(:program)
  end
  
  def destroy
    current_user.programs.delete(Program.find(params[:id]))
    flash[:notice] = 'Program removed'
    redirect_to :back
  end
end