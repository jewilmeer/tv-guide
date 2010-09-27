class Admin::EpisodesController < AdminAreaController
  before_filter :get_episode, :except => :index
  
  def index
    @episodes = Episode.includes(:program).joins(:users).by_airs_at(:desc).limited(30).all
  end
  
  protected
  def get_episode
    @episode = Episode.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @episode
  end
end