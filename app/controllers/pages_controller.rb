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
    @program_updates = ProgramUpdate.real_updates.by_id(:desc).limit(50)
    @new_episodes    = Episode.by_created_at(:desc).limit(30).includes(:program).where(['DATE(programs.created_at) <> DATE(episodes.created_at)'])
  end
end