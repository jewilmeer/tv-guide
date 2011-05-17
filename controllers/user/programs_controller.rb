class User::ProgramsController < UserAreaController
  before_filter :require_trust, :only => :aired
  
  def index
    @program_preference= current_user.program_preferences.build
    @programs          = @user.programs.by_name
    basic_episodes     = Episode.watched_by_user(@user.programs)
    @upcoming_episodes = basic_episodes.next_airing.limit(20)
    @past_episodes     = basic_episodes.last_aired.includes(:downloads).limit(20)
    @program_cache_key = @user.programs.by_updated_at.last
    @search_terms      = SearchTermType.all
    # response.headers['Cache-Control'] = "public, max-age=#{5.minutes.seconds}" if Rails.env.production?
  end

  def aired
    @episodes           = Episode.watched_by_user(@user.programs).last_aired.downloaded.limit(30).includes(:program)
  end
  
  def destroy
    current_user.programs.delete(Program.find(params[:id]))
    current_user.programs.first.touch #expire cache
    flash[:notice] = 'Program removed'
    redirect_to :back
  end
end