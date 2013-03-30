class ProgramsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :find_program, :except => [:index, :create, :suggest, :search, :check]
  newrelic_ignore :only => [:check]

  respond_to :html, :json, :js

  def index
    @programs = Program.search_program(params[:q]).order('status, name').page params[:page]
    if params[:q].present? && @programs.length == 1 && @programs.first.name.downcase == params[:q].downcase
      redirect_to @programs.first
    else
      respond_with :programs => @programs
    end
  end

  def guide
    @search_terms      = SearchTermType.all
    @upcoming_episodes = Episode.next_airing.includes(:program)
    @past_episodes     = Episode.last_aired.includes(:program).includes(:downloads).page params[:page]
  end

  def show
    @program        = Program.find(params[:id])
    @featured_image = @program.series_image || @program.images.series.random.first
    @search_terms   = SearchTermType.all
  end

  def suggest
    @programs = Program.tvdb_search(params[:q].downcase)
  end

  def edit
    # @needs_update = @program.needs_update?
    # render :json => @needs_update
    render :json => true
  end

  def update
    if params[:program]
      @program.update_attributes(params[:program])
      # check if we can find the image
      @image_id = params[:program].detect{|k,v| k.include?('_image_id')}.try(:last)
    else
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
      render :nothing => true
    end
  end

  def destroy
    @program = Program.find(params[:id])

    raise ActiveRecord::RecordNotFound unless @program
    if current_user.programs.delete(@program)
      flash[:notice] = "#{@program.name} removed"
    else
      flash[:error] = 'Program could not be removed'
    end
    redirect_to root_path
  end

  def search
    @programs = Program.search_program(params[:term]).limit(25).all(:select => 'id, name')
    respond_to do |format|
      format.js { render :json => @programs.map{|p| {:id => p.id, :label => p.name, :value => p.name} } }
    end
  end

  # 15 minutes cronjob
  def check
    status = []
    program = Program.where{ status == 'Continuing' }.order(:last_checked_at).limit(5).sample
    status << "Updated #{program.name}" if program.tvdb_full_update

    episode_scope = Episode.where('airs_at IS NOT NULL').airs_at_inside(1.week.ago, 2.hours.ago)
    episode_to_download = episode_scope.to_be_downloaded.sample
    episode_to_update   = episode_scope.without_image.sample

    if episode_to_download
      status << "="*20+"\n"
      status << "Downloading nzb #{episode_to_download.program.name} - #{episode_to_download.full_episode_title}: #{episode_to_download.download_all}"
      status << "="*20+"\n"
    end
    if episode_to_update
      status << "Updating #{episode_to_update.program.name} - #{episode_to_update.full_episode_title}: #{episode_to_update.tvdb_update}"
    end
    render :text => status * "\n<br />"
  end

  def find_program
    @program = Program.find(params[:id]) if params[:id]
  end

  protected
  def sort_column
    Program.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
