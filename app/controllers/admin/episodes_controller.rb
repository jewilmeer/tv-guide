class Admin::EpisodesController < AdminAreaController
  before_filter :get_episode, :except => :index
  
  def download
    if @episode.get_nzb
      flash[:notice] = "Download completed"
    else
      flash[:error]  = "Failed to download nzbfile"
    end
    redirect_to [:admin, @episode.program]
  end

  protected
  def get_episode
    @episode = Episode.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @episode
  end
end