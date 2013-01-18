class PagesController < ApplicationController
  caches_page :show, :if => Proc.new{|r| Rails.env.production? }

  # hompage
  def index
    if current_user
      redirect_to user_programs_path( current_user )
    else
      redirect_to guide_programs_path
    end
  end

  def sitemap
  end
end