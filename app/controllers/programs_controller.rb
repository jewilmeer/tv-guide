class ProgramsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :find_program, :except => [:index, :create, :suggest, :search, :check]
  newrelic_ignore :only => [:check]

  def index
    @programs = Program.search_program(params[:q]).order(sort_column + ' ' + sort_direction).paginate :per_page => 30, :page => params[:page]
    if params[:q].present? && @programs.length == 1 && @programs.first.name.downcase == params[:q].downcase
      redirect_to @programs.first
    end
  end
  
  def guide
    @search_terms      = SearchTermType.all
    @upcoming_episodes = Episode.next_airing
    @past_episodes     = Episode.last_aired.includes(:downloads).limit(20)

    # @future_episodes = Episode.by_airs_at.airs_at_after(Time.now).limited(30)
    # @past_episodes   = Episode.by_airs_at(:desc).airs_at_before(Time.now).limited(30)
  end
  
  def show
    @program        = Program.find(params[:id], :include => :episodes)
    @featured_image = @program.series_image || @program.images.series.random.first
  end
    
  def suggest
    @programs = Program.tvdb_search(params[:q].downcase)
    # exact match?
    # if @programs.length == 1 && @programs.first.name.downcase == params[:q].downcase
    #   current_user.programs << Program.find_or_create_by_tvdb_id(@programs.first.tvdb_id)
    #   redirect_to :back
    # end
  end
    
  def create
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
    @image_types = Image.distinctly('images.image_type').group('image_type').all.map(&:image_type)
    @image_type  = params[:image_type] || @image_types.last
    @images      = @program.images.image_type(@image_type).paginate :per_page => params[:per_page] ||= 5, :page => params[:page]
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
