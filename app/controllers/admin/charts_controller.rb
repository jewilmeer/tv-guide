class ::Admin::ChartsController < AdminAreaController
  respond_to :json, :html
  def episodes
    episode_data = Episode.group('DATE(created_at)').count
    dates = episode_data.keys
    data = {}
    dates.last.step(dates.first, -1.day) do |date|
      data[date] = episode_data.find{|k,v| date == k}.try(:last) || 0
    end
    respond_with data
  end
end