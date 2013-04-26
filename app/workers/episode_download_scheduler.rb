class EpisodeDownloadScheduler
  include Sidekiq::Worker

  def perform(time_ago=5.minutes.ago)
    Episode.without_download.airs_at_inside(time_ago, Time.now).each do |episode|
      EpisodeDownloader.perform_async episode.id
    end
  end
end