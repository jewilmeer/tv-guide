class StationsController < ApplicationController
  before_filter :authenticate_user_from_token!, only: :download_list
  before_filter :require_trust, only: :download_list

  def index
    @stations = Station.all
  end

  def show
    @station            = Station.friendly.find params[:id]
    @past_episodes      = @station.episodes.
                            includes(:program, :downloads).
                            last_aired_from(Date.today).
                            page params[:page]
    @next_episodes      = @station.episodes.
                            includes(:program).
                            next_airing_from(Date.today)
    @last_updated_episode = @station.episodes.order('updated_at').last
  end

  def download_list
    @station  = Station.friendly.find params[:id]
    @episodes = @station.episodes.last_aired.downloaded.limit(30)
  end
end