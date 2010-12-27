class ProgramsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :find_program, :except => [:index, :create, :suggest, :search, :check]
  newrelic_ignore :only => :check

  def index
    @programs = Program.search(params[:q]).by_status.order(sort_column + ' ' + sort_direction).paginate :per_page => 30, :page => params[:page]
  end
  
  def guide
    @future_episodes = Episode.by_airs_at.airs_at_after(Time.now).limited(30)
    @past_episodes   = Episode.by_airs_at(:desc).airs_at_before(Time.now).limited(30)
  end
  
  def show
    @program = Program.find(params[:id], :include => {:seasons => :episodes})
  end
    
  def suggest
    @programs = Program.tvdb_search(params[:q].downcase)
    # exact match?
    if @programs.length == 1 && @programs.first['seriesname'].downcase == params[:q].downcase
      current_user.programs << Program.find_or_create_by_name(@programs.first['seriesname'])
      redirect_to :back
    end
  end
    
  def create
    program_name = Program.new(params[:program]).guess_correct_name
    @program     = Program.find_or_create_by_name(program_name, params[:program])
    current_user.programs << @program if @program && current_user
    if @program.save
      flash[:notice] = "#{@program.name} added to watchlist"
      redirect_to :programs
    else
      @programs = Program.all
      render :index
    end
  end
  
  def edit
    @needs_update = @program.needs_update?
    render :json => @needs_update
  end
  
  def update
    @program.tvdb_update
    render :nothing => true
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
    @programs = Program.search(params[:term]).all(:select => 'id, name')
    respond_to do |format|
      format.js { render :json => @programs.map{|p| {:id => p.id, :label => p.name, :value => p.name} } }
    end
  end
  
  # 15 minutes cronjob
  def check
    status = []
    program = Program.status_equals('Continuing').by_last_checked_at.limit(1).first
    status << "Updated #{program.name}" if program.tvdb_update
    nzbs_to_get = Episode.airs_at_present.airs_at_inside(1.week.ago, 2.hours.ago).no_downloads_present.limited(5)
    if nzbs_to_get.any?
      nzbs_to_get.each do |episode|
        status << "Downloading nzb #{episode.program.name} - #{episode.full_episode_title}: #{episode.get_nzb}"
      end
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
