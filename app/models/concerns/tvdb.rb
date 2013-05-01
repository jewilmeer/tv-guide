require 'active_support/concern'

module Concerns
  module TVDB
    extend ActiveSupport::Concern

    included do
      before_save :tvdb_refresh, if: ->(){ self.tvdb_id_changed? }
      before_create ->(){ self.last_checked_at= 1.year.ago }
      # scopes
      def self.tvdb_client
        TvdbParty::Search.new(TVDB_API)
      end

      def self.tvdb_search query
        tvdb_client.search( query ).map{|r| from_tvdb(r) }
      end

      def self.from_tvdb(tvdb_result)
        self.find_or_create_by_name tvdb_result.name do |program|
          program.apply_tvdb_attributes tvdb_result
        end
      end

      def self.tvdb_updated_tvdb_ids(timestamp)
        tvdb_client.get_series_updates(timestamp.to_i)['Series'] || []
      end

      def self.tvdb_apply_update_since since=5.minutes.ago
        updated_ids = tvdb_updated_tvdb_ids(since)
        programs = updated_ids.map do |tvdb_id|
          self.where(tvdb_id: tvdb_id).first_or_create
        end
        programs.map { |program| program.tvdb_full_update; program }
      end
    end

    def tvdb_client
      self.class.tvdb_client
    end

    def tvdb_serie
      tvdb_client.get_series_by_id self.tvdb_id
    end

    def tvdb_full_update
      [
        tvdb_refresh,
        tvdb_refresh_episodes,
        update_episode_counters
      ]

      # cleanup invalid episodes
      return self.destroy unless self.valid?

      self.touch(:last_checked_at)
    end

    def tvdb_refresh
      self.apply_tvdb_attributes tvdb_serie
    end

    def tvdb_refresh_episodes
      logger.debug "=== Refreshing episodes"
      tvdb_client.get_all_episodes_by_id(self.tvdb_id).map do |tvdb_episode|
        # remove special episodes
        next if [0, 99].include? tvdb_episode.season_number.to_i
        next if [0, 99].include? tvdb_episode.number.to_i

        episode = self.episodes.find_or_initialize_by_tvdb_id tvdb_episode.id
        episode.apply_tvdb_attributes tvdb_episode
        episode.save
      end
    end

    def update_episode_counters
      self.max_season_nr= self.episodes.order('season_nr desc').first.try(:season_nr)
      self.current_season_nr= self.episodes.last_aired.first.try(:season_nr) || 1
      save
    end

    def apply_tvdb_attributes tvdb_result
      return unless tvdb_result
      self.tvdb_id        = tvdb_result.id
      self.name           = tvdb_result.name unless self.name.present?
      self.search_name    = tvdb_result.name unless self.search_name.present?
      self.tvdb_name      = tvdb_result.name
      self.airs_dayofweek = tvdb_result.airs_dayofweek
      self.airs_time      = tvdb_result.air_time
      self.status         = tvdb_result.status
      self.runtime        = tvdb_result.runtime
      self.network        = tvdb_result.network
      self.overview       = tvdb_result.overview
      tvdb_result.genres.each do |genre|
        genre = Genre.find_or_create_by_name(genre)
        self.genres << genre
      end
      self.tvdb_last_update = Time.now
      self
    end

  end
end