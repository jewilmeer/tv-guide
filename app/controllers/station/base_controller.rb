class Station::BaseController < ApplicationController
  def find_station
    Station.friendly.find params[:station_id]
  end
end