class SeasonsController < ApplicationController
  before_filter :find_season, :except => :index
  def index
    @season = Seasons.find(params[:id])
  end
  
  def show
  end
  
  def find_season
    @season = Season.first(:conditions => {:program_id => params[:program_id], :id => params[:id]}, :include => [:program, :episodes]) if params[:id] && params[:program_id]
    raise ActiveRecord::RecordNotFound unless @season
  end
  
end
 