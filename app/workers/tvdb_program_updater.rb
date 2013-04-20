class TvdbProgramUpdater
  include Sidekiq::Worker

  def perform(tvdb_id)
    program = Program.where(tvdb_id: tvdb_id).first_or_create
    program.tvdb_full_update
  end
end