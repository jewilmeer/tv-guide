class User::ProgramsController < UserAreaController
  before_filter :authenticate_user!, :only => :aired
  before_filter :require_trust, :only => :aired

  def index
    @station           = user.stations.personal.first
    @past_episodes     = @station.episodes.last_aired.page params[:page]
    @upcoming_episodes = @station.episodes.next_airing

    @personal_stations   = user.stations
    @genre_stations      = Station.where('taggable_type=?', 'Genre')
    @other_user_stations = Station.where('taggable_type=?', 'User') - @user.stations
  end

  def aired
    @station  = User.find_by_login(params[:user_id]).stations.personal.first
    @episodes = @station.episodes.last_aired.downloaded.limit(30)
  end

  def user
    user = User.find_by_login! params[:user_id]
  end
end