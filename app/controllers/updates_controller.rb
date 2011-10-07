class UpdatesController < ApplicationController
  before_filter :get_program
  
  def index
    @updates = @program.program_updates.by_id(:desc)
  end
  
  def get_program
    @program = Program.find(params[:program_id])
  end
end