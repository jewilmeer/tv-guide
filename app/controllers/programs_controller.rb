class ProgramsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :find_program, :except => [:index, :create, :suggest, :search, :check]
  newrelic_ignore :only => [:check]

  respond_to :html, :json, :js

  def index
    @program_cache = Program.last_updated.first
    @programs = cache([@program_cache, params[:q] || false]) { Program.search_program(params[:q]).order(sort_column + ' ' + sort_direction) }
    if params[:q].present? && @programs.length == 1 && @programs.first.name.downcase == params[:q].downcase
      redirect_to @programs.first
    else
      # response.headers['Cache-Control'] = 'public, max-age=300' #cache for 5 minutes
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
    program = Program.status_equals('Continuing').by_last_checked_at.limit(1).first
    status << "Updated #{program.name}" if program.tvdb_full_update
    nzbs_to_get = Episode.airs_at_present.airs_at_inside(1.week.ago, 2.hours.ago).no_downloads_present.limited(2).random
    if nzbs_to_get.any?
      nzbs_to_get.each do |episode|
        status << "Downloading nzb #{episode.program.name} - #{episode.full_episode_title}: #{episode.get_nzb}"
        episode.tvdb_update #update coverimage as well
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
