class EpisodeDownloadScheduler
  include Sidekiq::Worker

  def perform
    Episode.without_download.airs_at_inside(1.day.ago, Time.now).each do |episode|
      EpisodeDownloader.perform_async episode.id
    end
  end
end