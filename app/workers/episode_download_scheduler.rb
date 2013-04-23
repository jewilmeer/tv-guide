class EpisodeDownloadScheduler
  include Sidekiq::Worker

  def perform
    Episode.without_download.airs_at_inside(5.minutes.ago, Time.now).each do |episode|
      EpisodeDownloader.perform_async episode.id
    end
  end
end