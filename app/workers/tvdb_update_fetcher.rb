class TvdbUpdateFetcher
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(timestamp=5.minutes.ago)
    tvdb_ids = Program.tvdb_updated_tvdb_ids(timestamp)
    Rails.logger.tagged(:TVDB) { Rails.logger.info { "Found updated tvdb_ids: #{tvdb_ids.inspect}}" } }

    binding.pry

    tvdb_ids.each do |tvdb_id|
      program = Program.find_or_create_by(tvdb_id: tvdb_id) do |program|
        program.active = false
      end

      next unless program.needs_tvdb_update?
      Rails.logger.tagged(:TVDB) { Rails.logger.debug("Schedule #{tvdb_id}: #{program.name}") }

      TvdbProgramUpdater.perform_async tvdb_id
    end
  end
end