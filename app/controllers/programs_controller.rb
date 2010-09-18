class ProgramsController < ApplicationController
  
  before_filter :find_program, :except => [:index, :create, :suggest, :search, :check]
  
  def index
    # @programs = Program.by_name
    @future_episodes = Episode.by_airs_at.airs_at_after(Time.now).limited(30)
    @past_episodes   = Episode.by_airs_at(:desc).airs_at_before(Time.now).limited(30)
  end
  
  def show
    @program = Program.find(params[:id], :include => {:seasons => :episodes})
  end
    
  def suggest
    @programs = Program.search(params[:q].downcase)
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
    @programs = Program.search_for(params[:term], :on => [:name, :search_term]).all(:select => 'id, name')
    respond_to do |format|
      format.js { render :json => @programs.map{|p| {:id => p.id, :label => p.name, :value => p.name} } }
    end
  end
  
  # 15 minutes cronjob
  def check
    program = Program.by_last_checked_at.limit(1).first
    program.tvdb_update rescue ''
    nzb_to_get = Episode.airs_at_present.airs_at_inside(1.week.ago, 2.hours.ago).nzb_file_name_missing.last
    nzb_to_get.get_nzb if nzb_to_get
    render :text => "updated #{program.name}"
  end
  
  def find_program
    @program = Program.find(params[:id]) if params[:id]
  end
end