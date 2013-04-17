class StationsController < ApplicationController
  def index
    @stations = Station.all
  end

  def show
    @station = Station.find params[:id]
    @search_terms = SearchTermType.scoped


    @past_episodes = @station.episodes.last_aired
      .includes(:program, downloads: :search_term_type)
      .page(params[:page]).per_page(10)

    @next_episodes = @station.episodes.next_airing
  end
end