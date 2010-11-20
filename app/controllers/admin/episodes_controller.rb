class Admin::EpisodesController < AdminAreaController
  helper_method :sort_column, :sort_direction
  before_filter :get_episode, :except => :index
  
  def index
    @episodes = Episode.order(sort_column + ' ' + sort_direction).includes(:program).joins(:users).paginate :per_page => 25, :page => params[:page]
  end

  def update
    @episode.get_nzb
    redirect_to :back
  end
  
  protected
  def get_episode
    @episode = Episode.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @episode
  end
  
  def sort_column
    Episode.column_names.include?(params[:sort]) ? params[:sort] : "airs_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end