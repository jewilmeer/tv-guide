class EpisodeDownloadScheduler
  include Sidekiq::Worker

  def perform(time_ago=1.hour.ago)
    Rails.logger.fatal "Found #{Episode.downloadable.airs_at_inside(time_ago, Time.now).count} schedulable downloads"
    Episode.downloadable.airs_at_inside(time_ago, Time.now).all.each do |episode|
      EpisodeDownloader.perform_async episode.id
    end
  end
end