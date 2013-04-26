class EpisodeDownloadScheduler
  include Sidekiq::Worker

  def perform(time_ago=2.days.ago)
    Episode.downloadable.airs_at_inside(time_ago, Time.now).each do |episode|
      EpisodeDownloader.perform_async episode.id
    end
  end
end