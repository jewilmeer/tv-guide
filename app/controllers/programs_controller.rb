class ProgramsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :find_program, :except => [:index, :create, :suggest, :search, :check]
  newrelic_ignore :only => [:check]

  respond_to :html, :json, :js

  def index
    @programs = Program.search_program(params[:q]).order(:name)
    if params[:q].present? && @programs.length == 1 && @programs.first.name.downcase == params[:q].downcase
      redirect_to @programs.first
    else
      respond_with :programs => @programs
    end
  end

  def guide
    @search_terms      = SearchTermType.all
    @upcoming_episodes = Episode.next_airing.includes(:program)
    @past_episodes     = Episode.last_aired.includes(:program).includes(:downloads).limit(20)
  end

  def show
    @program        = Program.find(params[:id], :include => :episodes)
    @featured_image = @program.series_image || @program.images.series.random.first
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
    program = Program.where{ status == 'Continuing' }.order(:last_checked_at).limit(1).first
    status << "Updated #{program.name}" if program.tvdb_full_update
    episode_scope = Episode.where('airs_at IS NOT NULL').airs_at_inside(1.week.ago, 2.hours.ago).limit(1)
    nzbs_to_get         = episode_scope.to_be_downloaded
    episodes_to_update  = episode_scope.without_image

    binding.pry

    if nzbs_to_get.any?
      status << "<<< Getting nzb's >>>"
      nzbs_to_get.each do |episode|
        status << "Downloading nzb #{episode.program.name} - #{episode.full_episode_title}: #{episode.get_nzb}"
      end
      status << "<<< Updating episodes >>>"
      episodes_to_update.each do |episode|
        status << "Updating #{episode.program.name} - #{episode.full_episode_title}: #{episode.tvdb_update}"
      end
    end
    render :text => status * "\n<br />"
  end

  def banners
    @image_types = Image.distinctly('images.image_type').group('image_type').all.map(&:image_type).compact
    @image_type  = params[:image_type] || @image_types.last
    order = params[:order] || 'created_at desc'
    @placeholder = @program.series_image
    @images      = @program.images.image_type(@image_type).limit(params[:per_page] || 5).order(order)
    @images.unshift(@placeholder) if @placeholder && @images.exclude?( @placeholder )
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
