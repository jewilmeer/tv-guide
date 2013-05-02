class StationsController < ApplicationController
  def index
    @stations = Station.all
  end

  def show
    @station            = Station.find params[:id]
    @past_episodes      = @station.episodes.last_aired.page params[:page]
    @next_episodes      = @station.episodes.next_airing

    @personal_stations   = current_user.stations if user_signed_in?
    @personal_stations   ||= []
    @genre_stations      = Station.where('taggable_type=?', 'Genre')
    @other_user_stations = Station.where('taggable_type=?', 'User') - @personal_stations
  end
end