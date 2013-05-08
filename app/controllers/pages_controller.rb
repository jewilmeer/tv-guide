class PagesController < ApplicationController
  caches_page :show, :if => Proc.new{|r| Rails.env.production? }

  # hompage
  def index
    if current_user
      redirect_to current_user.stations.personal.first
    else
      redirect_to guide_programs_path
    end
  end

  def sitemap
  end
end