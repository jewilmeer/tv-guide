class NetworksController < ApplicationController
  def index
    @networks = Network.order('name')
  end

  def show
    @network = Network.find params[:id]
    @programs = @network.programs.aired.order('status, first_aired desc')
  end
end