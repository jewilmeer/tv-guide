class TvdbProgramUpdater
  include Sidekiq::Worker

  def perform(tvdb_id)
    Program.find_or_create_by(tvdb_id: tvdb_id).tvdb_full_update
  end
end