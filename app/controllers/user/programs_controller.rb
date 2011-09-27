class User::ProgramsController < UserAreaController
  before_filter :require_trust, :only => :aired
  
  def index
    @program_preference= current_user.program_preferences.build(:search_term_type => SearchTermType.first) if current_user == @user
    @programs          = @user.programs.by_name
    basic_episodes     = Episode.watched_by_user(@user.programs)
    @upcoming_episodes = basic_episodes.next_airing.limit(20)
    @past_episodes     = basic_episodes.last_aired.includes(:downloads).limit(20)
    @program_cache_key = @user.programs.by_updated_at.last
    @search_terms      = SearchTermType.all
  end

  def aired
    @episodes           = Episode.watched_by_user(@user.programs).last_aired.downloaded.limit(30).includes(:program)
  end
  
  def destroy
    @program = Program.find(params[:id])
    current_user.programs.delete(@program)
    current_user.programs.first.touch #expire cache

    logger.debug "program: #{@program.inspect}"
    respond_to do |format|
      format.html {
        redirect_to :back, :notice => 'Program removed'    
      }
      format.js { }
    end
  end

  def update
    @program = Program.find(params[:id])
    @program.tvdb_full_update
    render :text => 'ok'
  end
end