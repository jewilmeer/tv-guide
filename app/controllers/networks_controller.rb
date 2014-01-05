class NetworksController < ApplicationController
  def index
    @networks = Network.order('name')
  end

  def show
    @network = Network.find params[:id]
    @programs = @network.programs.aired.where(status: 'Continuing').order('first_aired desc')
  end
end