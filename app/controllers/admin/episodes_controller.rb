class Admin::EpisodesController < AdminAreaController
  helper_method :sort_column, :sort_direction
  before_filter :get_episode, :except => :index
  
  def index
    basic_scope = Episode.order(sort_column + ' ' + sort_direction).includes(:program)
    basic_scope = basic_scope.airs_at_in_past unless params[:include_future]

    logger.debug "page: #{params[:page]}"

    @episodes = basic_scope.paginate :per_page => 25, :page => params[:page]

    respond_to do |format|
      format.html
      format.js do 
        content = render_to_string( @episodes )
        render :text => content, :status => 200
      end
    end
  end

  def update
    success = @episode.get_nzb
    respond_to do |format|
      format.html { redirect_to :back }
      format.js do
        if params[:row]
          @episode_template = render_to_string(:partial => '/episodes/episodes', :locals => {:episode => @episode})
        else
          @episode_template = render_to_string(:partial => '/episodes/episode', :locals => {:episode => @episode})
        end
      end
    end
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
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end