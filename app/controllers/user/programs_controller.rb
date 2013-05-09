class User::ProgramsController < UserAreaController
  before_filter :authenticate_user!, :only => :aired
  before_filter :require_trust, :only => :aired

  def aired
    @station  = user.stations.personal.first
    @episodes = @station.episodes.last_aired.downloaded.limit(30)
  end

  def user
    User.find_by_login! params[:user_id]
  end
end