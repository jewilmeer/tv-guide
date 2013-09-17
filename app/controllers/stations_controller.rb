class StationsController < ApplicationController
  before_filter :authenticate_user_from_token!, :only => :download_list
  before_filter :require_trust, :only => :download_list

  def index
    @stations = Station.all
  end

  def show
    @station            = Station.friendly.find params[:id]
    @past_episodes      = @station.episodes.last_aired.page params[:page]
    @next_episodes      = @station.episodes.next_airing
  end

  def download_list
    @station  = Station.friendly.find params[:id]
    @episodes = @station.episodes.last_aired.downloaded.limit(30)
  end
end