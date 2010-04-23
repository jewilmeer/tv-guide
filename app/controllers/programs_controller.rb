class ProgramsController < ApplicationController
  before_filter :find_program, :except => [:index, :create]
  
  def index
    @programs = Program.by_name.all(:include => {:seasons => :episodes})
    @program = Program.new
  end
  
  def show
  end
    
  def create
    @program = Program.find_or_create_by_name(params[:program][:name], params[:program])
    current_user.programs << @program if @program && current_user
    if @program.save
      flash[:notice] = "#{@program.name} added to watchlist"
      redirect_to :programs
    else
      @programs = Program.all
      render :index
    end
  end
  
  def destroy
    @program = Program.find(params[:id])
    
    raise ActiveRecord::RecordNotFound unless @program
    if @program.destroy
      flash[:notice] = "#{@program.name} removed"
    else
      flash[:error] = 'Program could not be removed'
    end
    redirect_to root_path
  end
  
  def find_program
    @program = Program.find(params[:id]) if params[:id]
    raise ActiveRecord::RecordNotFound unless @program
  end
end
