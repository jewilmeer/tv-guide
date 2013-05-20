class PagesController < ApplicationController
  def index
    if current_user
      redirect_to current_user.stations.personal.first
    else
      redirect_to guide_programs_path
    end
  end

  def sitemap
    @programs = Program.where(status: 'Continuing').order('updated_at desc')
    @episodes = Episode.includes(:program).airs_at_inside(1.week.ago, 1.weeks.from_now).order('episodes.updated_at').limit(1000)
  end
end