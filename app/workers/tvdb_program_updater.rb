class TvdbProgramUpdater
  include Sidekiq::Worker

  def perform(tvdb_id)
    Program.find_by(tvdb_id: tvdb_id).tvdb_full_update
  end
end