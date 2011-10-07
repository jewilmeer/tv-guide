class InteractionsController < ApplicationController
  def create
    @episode.interactions.create(params[:interaction])
    respond_to do |format|
      format.js { render :status => 200 }
    end
  end
  
  protected
  def get_object
    @episode = Episode.find(params[:episode_id])
    raise ActiveRecord::RecordNotFound unless @episode
  end
end