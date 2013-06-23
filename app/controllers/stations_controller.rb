class StationsController < ApplicationController
  before_filter :authenticate_user!, :only => :download_list
  before_filter :require_trust, :only => :download_list

  def index
    @stations = Station.all
  end

  def show
    @station            = Station.friendly.find params[:id]
    @past_episodes      = @station.episodes.last_aired.page params[:page]
    @next_episodes      = @station.episodes.next_airing

    @personal_stations   = current_user.stations if user_signed_in?
    @personal_stations   ||= []
    @genre_stations      = Station.genre_stations
    @other_user_stations = Station.user_stations - @personal_stations
  end

  def download_list
    @station  = Station.friendly.find params[:id]
    @episodes = @station.episodes.last_aired.downloaded.limit(30)
  end
end