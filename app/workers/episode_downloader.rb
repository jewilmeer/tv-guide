class EpisodeDownloader
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform episode_id
    episode = Episode.find(episode_id)
    # we only want an initial download
    return if episode.downloads.any?

    # auto reschedule if download failed
    episode.download_with_reschedule
  end
end