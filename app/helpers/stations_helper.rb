module StationsHelper
  def personal_stations
    return [] unless user_signed_in?
    current_user.stations
  end

  def other_user_stations
    Station.filled.user_stations - personal_stations
  end

  def genre_stations
    Station.genre_stations
  end
end