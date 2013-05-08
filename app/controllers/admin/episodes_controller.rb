class Admin::EpisodesController < AdminAreaController
  respond_to :html, :json, :js
  before_filter :get_episode, :except => [:index, :destroy]

  def index
    basic_scope = Episode.airs_at_in_past.includes(:program)

    @episodes = basic_scope.page params[:page]
  end

  def show
    redirect_to edit_admin_episode_path(@episode)
  end

  def update
    @episode.update_attributes params[:episode]
    redirect_to :back, :notice => 'updated!'
  end

  def destroy
    Episode.destroy params[:id]
    redirect_to admin_episodes_path
  end

  protected
  def get_episode
    @episode = Episode.find(params[:id])
  end
end