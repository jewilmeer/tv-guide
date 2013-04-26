class EpisodeDownloader
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform episode_id
    Episode.find(episode_id).download_all
  end
end