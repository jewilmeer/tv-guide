class PagesController < ApplicationController
  caches_page :show, :if => Proc.new{|r| Rails.env.production? }
  
  # hompage
  def index
  end
  
  def show
    # redirect_to :programs if params[:id] == 'home' && current_user
    @page = Page.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound unless @page
  end
  
  def program_updates
    @program_updates = ProgramUpdate.real_updates.by_id(:desc).limited(10)
  end
end