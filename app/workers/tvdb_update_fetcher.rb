class TvdbUpdateFetcher
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(timestamp=5.minutes.ago)
    Program.tvdb_updated_tvdb_ids(timestamp).each do |tvdb_id|
      TvdbProgramUpdater.perform_async tvdb_id
    end
  end
end