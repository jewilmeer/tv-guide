class Admin::EpisodesController < AdminAreaController
  respond_to :html, :json, :js
  before_filter :get_episode, :except => [:index, :destroy]

  def index
    if params[:program_id]
      @program = Program.friendly.find params[:program_id]
      @nav = program_nav_links

      basic_scope = @program.episodes.order('sort_nr desc').includes(:program)
    else
      basic_scope = Episode.active
        .airs_at_in_past
        .order('episodes.updated_at desc')
        .includes(:program)
    end

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
    redirect_to :back
  end

  protected
  def get_episode
    @episode = Episode.find(params[:id])
  end
end