class EpisodeDownloadScheduler
  include Sidekiq::Worker

  def perform(time_ago=1.hour.ago)
    Episode.downloadable.airs_at_inside(time_ago, Time.now).pluck(:id).each do |episode_id|
      EpisodeDownloader.perform_async episode_id
    end
  end
end