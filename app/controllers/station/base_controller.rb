class Station::BaseController < ApplicationController
  def find_station
    Station.find params[:station_id]
  end
end