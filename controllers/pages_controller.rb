class PagesController < ApplicationController
  caches_page :show, :if => Proc.new{|r| Rails.env.production? }
  
  # hompage
  def index
    @upcoming_episodes = Episode.airs_at_after(Time.now).by_airs_at.limit(5)
    @latest_episodes   = Episode.by_created_at(:desc).limit(5).includes(:program).where(['DATE(programs.created_at) <> DATE(episodes.created_at)'])
    response.headers['Cache-Control'] = "public, max-age=#{5.minutes}" if Rails.env.production?
  end
  
  def show
    @page = Page.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound unless @page
    response.headers['Cache-Control'] = "public, max-age=#{1.hour.seconds}" if Rails.env.production?
  end
  
  def sitemap
  end
  
  def program_updates
    @program_updates = ProgramUpdate.real_updates.by_id(:desc).limit(50)
    @new_episodes    = Episode.by_created_at(:desc).limit(30).includes(:program).where(['DATE(programs.created_at) <> DATE(episodes.created_at)'])
    response.headers['Cache-Control'] = "public, max-age=#{5.minutes.seconds}" if Rails.env.production?
  end
end