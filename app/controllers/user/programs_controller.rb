class User::ProgramsController < UserAreaController
  before_filter :authenticate_user!, :only => [:aired, :index]
  before_filter :require_trust, :only => :aired

  def index
    basic_episodes     = Episode.watched_by_user(@user.programs)
    @past_episodes     = basic_episodes.last_aired.includes(:program, downloads: :search_term_type)
                          .page(params[:page]).per_page(10)
    @search_terms      = SearchTermType.all

    respond_to do |format|
      format.html do
        @program_preference= current_user.program_preferences.build(:search_term_type => SearchTermType.first) if current_user == @user
        @programs          = @user.programs.order(:name)
        @upcoming_episodes = basic_episodes.next_airing
        @program_cache_key = @user.programs.order(:updated_at).last
      end
      format.js {}
    end
  end

  def show
    if params[:id].length == 21
      redirect_to tokened_user_programs_path current_user, params[:id][1..21], :format => params[:format]
    else
      render :status => :not_found, :nothing => true
    end
  end

  def aired
    @episodes           = Episode.watched_by_user(@user.programs).last_aired.downloaded.limit(30).includes(:program)
  end

  def destroy
    @program = Program.find(params[:id])
    current_user.programs.delete(@program)
    current_user.programs.first.touch #expire cache

    respond_to do |format|
      format.html {
        redirect_to :back, :notice => 'Program removed'
      }
      format.js { }
    end
  end

  def update
    @program = Program.find(params[:id])
    current_user.interactions.create({
      :user => current_user,
      :program => @program,
      :interaction_type => "update program",
      :format => params[:format] || 'html',
      :end_point => url_for(@program),
      :referer          => request.referer,
      :user_agent       => request.user_agent
    })
    @program.tvdb_full_update
    render :text => 'document.location.href = document.location.href'
  end
end