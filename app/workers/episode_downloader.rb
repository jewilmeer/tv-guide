class EpisodeDownloader
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform episode_id
    episode = Episode.find(episode_id)
    # we only want an initial download
    return if episode.downloads.any?

    # reschedule if not downloaded and within 7 days or airing
    if !episode.download('hd') && episode.airs_at...episode.max_download_time === Time.now
      episode.delay_for(1.hour).download('hd')
    end
  end
end