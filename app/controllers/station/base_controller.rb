class Station::BaseController < ApplicationController
  def find_station
    Station.where(taggable_type: params[:station_type],
      taggable_id: params[:station_id]).first!
  end
end