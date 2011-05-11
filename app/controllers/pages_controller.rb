class PagesController < ApplicationController
  caches_page :show, :if => Proc.new{|r| Rails.env.production? }
  
  # hompage
  def index
    @featured_programs = (Episode.next_airing.distinct_program_id('episodes.airs_at').limit(3).map(&:program) | Episode.by_created_at(:desc).distinct_program_id('episodes.created_at').limit(3).map(&:program))
    @next_airing       = Episode.next_airing.limit(5)
    @last_aired        = Episode.by_created_at(:desc).limit(5).includes(:program).where(['DATE(programs.created_at) <> DATE(episodes.created_at)'])
  end
  
  def show
    @page = Page.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound unless @page
    # response.headers['Cache-Control'] = "public, max-age=#{1.hour.seconds}" if Rails.env.production?
  end
  
  def sitemap
  end
  
  def program_updates
    @program_updates = ProgramUpdate.real_updates.by_id(:desc).limit(50)
    @new_episodes    = Episode.by_created_at(:desc).limit(30).includes(:program).where(['DATE(programs.created_at) <> DATE(episodes.created_at)'])
    # response.headers['Cache-Control'] = "public, max-age=#{5.minutes.seconds}" if Rails.env.production?
  end
end