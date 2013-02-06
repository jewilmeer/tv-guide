class Admin::EpisodesController < AdminAreaController
  respond_to :html, :json, :js
  before_filter :get_episode, :except => :index

  def index
    basic_scope = Episode.airs_at_in_past.includes(:program)

    @episodes = basic_scope.page params[:page]
  end

  def show
    redirect_to edit_admin_episode_path(@episode)
  end

  def update
    respond_to do |format|
      format.html do
        @episode.update_attributes params[:episode]
        redirect_to :back, :notice => 'updated!'
      end
      format.js do
        success = @episode.tvdb_update && @episode.download_all
        partial = case params[:partial]
        when 'episodes'
          'episodes'
        when 'episode'
          'episode'
        when 'past_episode'
          @search_terms = SearchTermType.all
          'past_episode'
        when 'image_strip'
          @search_terms = SearchTermType.all
          'image_strip'
        else
        end
        @episode_template = render_to_string(:partial => "/episodes/#{partial}", :locals => {:episode => @episode})
      end
    end
  end

  def tvdb_update
    respond_with @episode.tvdb_update_hash
  end

  protected
  def get_episode
    @episode = Episode.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @episode
  end
end