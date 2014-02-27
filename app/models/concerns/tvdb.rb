require 'active_support/concern'

module Concerns
  module TVDB
    extend ActiveSupport::Concern

    included do
      after_create { self.delay.tvdb_full_update }
      validates :name, format: { without: /\A\*\*\*.*/ }

      # scopes
      def self.tvdb_client(tvdb_id= TVDB_API)
        TvdbParty::Search.new(tvdb_id)
      end

      def self.tvdb_updated_tvdb_ids(timestamp)
        Array(tvdb_client.get_series_updates(timestamp.to_i)['Series']).map(&:to_i)
      end

      def self.tvdb_search query
        tvdb_client.search( query ).map{|r| from_tvdb(r) }
      end

      def self.from_tvdb(tvdb_result)
        self.find_or_create_by(tvdb_id: tvdb_result.id) do |program|
          program.apply_tvdb_attributes tvdb_result
        end
      end

      def self.tvdb_apply_update_since since=5.minutes.ago
        tvdb_updated_tvdb_ids(since).map do |tvdb_id|
          first_or_create_by(tvdb_id: tvdb_id)
        end
      end
    end

    def tvdb_client
      self.class.tvdb_client
    end

    def tvdb_serie
      @tvdb_serie ||= tvdb_client.get_series_by_id tvdb_id
    end

    def tvdb_serie!
      raise TVDBNotFound unless tvdb_serie

      tvdb_serie
    end

    def tvdb_full_update
      # ignore recently updated, but inactive programs
      return if !active && last_checked_witin?(1.month)
      # do not continue if one of these fails
      return unless tvdb_refresh && tvdb_refresh_episodes && update_episode_counters

      # cleanup invalid programs
      return destroy unless valid?

      self.delay.tvdb_update_banners if active?
      touch(:last_checked_at)
    end

    def tvdb_refresh
      apply_tvdb_attributes tvdb_serie!
      update_active_state
      save!
    rescue TVDBNotFound, ActiveRecord::RecordInvalid
      destroy
      nil
    end

    def tvdb_episodes
      tvdb_client.get_all_episodes_by_id(self.tvdb_id)
    rescue MultiXml::ParseError
      []
    end

    def tvdb_refresh_episodes
      logger.debug "=== Refreshing episodes"
      tvdb_episodes.map do |tvdb_episode|
        # remove special episodes
        next if [0, 99].include? tvdb_episode.season_number.to_i
        next if [0, 99].include? tvdb_episode.number.to_i

        episode = episodes.where(tvdb_id: tvdb_episode.id).first_or_initialize
        episode.apply_tvdb_attributes tvdb_episode
        episode.save
      end
    end

    def update_active_state
      self.active = calculate_active
    end

    def update_active_state!
      update_active_state
      save!
    rescue ActiveRecord::RecordInvalid
      destroy
    end

    def update_episode_counters
      update_attributes({
        max_season_nr: self.episodes.order('season_nr desc').first.try(:season_nr),
        current_season_nr: (self.episodes.last_aired.first.try(:season_nr) || 1)
      })
    end

    def apply_tvdb_attributes tvdb_result
      self.tvdb_id        = tvdb_result.id
      self.name           = tvdb_result.name unless self.name.present?
      self.search_name    = tvdb_result.name unless self.search_name.present?
      self.tvdb_name      = tvdb_result.name
      self.first_aired    = tvdb_result.first_aired
      self.airs_dayofweek = tvdb_result.airs_dayofweek
      self.airs_time      = tvdb_result.air_time
      self.status         = tvdb_result.status
      self.runtime        = tvdb_result.runtime
      self.tvdb_rating    = tvdb_result.rating
      self.network        = Network.find_or_create_by(name: tvdb_result.network)
      self.overview       = tvdb_result.overview

      tvdb_result.genres.each do |genre_name|
        genre = Genre.find_or_create_by(name: genre_name)
        self.genres << genre unless genres.where(name: genre_name).any?
      end
      self
    end

    def tvdb_banners
      logger.debug "[#{Time.now.to_s(:long)}] Getting banners for #{name}"
      tvdb_client.get_banners_by_id(self.tvdb_id)
    end

    def tvdb_update_banners
      tvdb_banners.each do |banner|
        image = self.images.where(source_url: banner.url).first_or_initialize.tap do |image|
          image.image_type = [banner.banner_type, banner.banner_type2].compact.join(':')
        end
        image.save
      end
    end

    def calculate_active
      return true if stations.any?
      return false unless network && network.active
      return false if genres.inactive.any? || genres.none?
      return false unless tvdb_rating >= 7
      return false unless tvdb_banners.any?
      true
    end

    def last_checked_within?(timespan)
      last_checked_at < timespan.ago
    end
  end
end

class TVDBNotFound < StandardError; end