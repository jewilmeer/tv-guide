class Admin::EpisodesController < AdminAreaController
  before_filter :get_episode, :except => :index
  
  def index
    @episodes = Episode.group('episodes.id').includes(:program).joins(:users).by_airs_at(:desc).all
  end
  
  protected
  def get_episode
    @episode = Episode.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @episode
  end
end