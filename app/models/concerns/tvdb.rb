require 'active_support/concern'

module Concerns
  module TVDB
    extend ActiveSupport::Concern

    included do
      # scopes
      def self.only_tvdb_id
        select('id, tvdb_id')
      end

      def self.tvdb_client
        TvdbParty::Search.new(TVDB_API)
      end

      def self.tvdb_search query
        tvdb_client.search( query ).map{|r| self.from_tvdb(r) }
      end

      def self.from_tvdb( tvdb_result )
        self.new.apply_tvdb_attributes tvdb_result
      end

      def self.tvdb_ids
        @tvdb_ids ||= self.only_tvdb_id.all
      end

      def self.updates timestamp=Time.now.to_i, only_existing=true
        result = tvdb_client.get_series_updates( timestamp )['Series']
        result.reject{|tvdb_id| !tvdb_ids.include?(tvdb_id.to_s) } if result && only_existing
      end
    end

    def tvdb_banner_url
      "http://www.thetvdb.com/banners/" + banners.detect{|banner| banner[:subtype] == 'graphical' }[:path]
    rescue StandardError
      false
    end

    def tvdb_banner_urls
      banners.map do |banner|
        "http://www.thetvdb.com/banners/" + banner[:path]
      end
    end

    def tvdb_banner_filename
      return false unless tvdb_banner_url
      tvdb_banner_url.split('/').last
    end

    # tvdb_party implementation
    # validates
    def has_tvdb_connection?
      tvdb_id.present?
    end

    def tvdb_client
      self.class.tvdb_client
    end

    def tvdb_update(check_episodes=true)
      logger.debug "checking for #{self.name} updates"
      update_by_tvdb_id
      if check_episodes
        new_episodes = self.new_episodes
        logger.debug "="*20
        logger.debug "Found #{new_episodes.length} new episode(s), adding those"
        logger.debug "="*20
        new_episodes.map do |episode|
          e = Episode.from_tvdb(episode, self)
          self.episodes << e
        end
      end
      # should log something
      self.last_checked_at = self.tvdb_last_update = Time.now
      save!
    end

    def tvdb_last_update
      @tvdb_last_update ||= created_at
    end

    def tvdb_serie
      @tvdb_serie ||= tvdb_client.get_series_by_id self.tvdb_id
    end

    def apply_tvdb_attributes tvdb_result
      return unless tvdb_result
      self.tvdb_serie     = tvdb_result #cache the object
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
        genre = Genre.find_or_initialize_by_name(genre)
        self.genres << genre
      end
      self.tvdb_last_update = Time.now
      self
    end

    def update_by_tvdb_id
      return true unless fetch_remote_information
      result = tvdb_client.get_series_by_id self.tvdb_id
      apply_tvdb_attributes result
    end

    # get new episodes, skip those specials and filter the ones already on the website
    def new_episodes
      tvdb_episodes(true)
    end

    def add_episodes
      tvdb_episodes.map{|episode| self.episodes << Episode.from_tvdb( episode, self ) }
    end

    def tvdb_episodes(only_new=false)
      episodes = tvdb_client.get_all_episodes_by_id(self.tvdb_id)
      episodes = episodes.select{|episode| Episode.valid_season_or_episode_nr episode.season_number.to_i }
      if only_new
        all_tvdb_ids = self.episodes.tvdb_id.pluck(:tvdb_id)
        episodes = episodes.reject{|episode| all_tvdb_ids.include?(episode.id.to_i) }
      end
      episodes
    end

    def tvdb_full_update
      self.tvdb_update(false) && tvdb_full_episode_update && get_images && update_episode_counters
    end

    def tvdb_full_episode_update
      tvdb_episodes.map do |e|
        episode = self.episodes.find_by_nr_and_season_nr(e.number, e.season_number) || Episode.from_tvdb( e, self )
        episode.apply_tvdb_attributes e
        episode.save if episode.changed?
      end
    end

    def get_images
      current_image_urls = images.url.map(&:url)
      return unless tvdb_serie
      tvdb_serie.banners.reject{|banner| banner.url.blank? || banner.banner_type.blank? }.map do |banner|
        image = Image.find_or_initialize_by_url(banner.url)
        image.programs << self unless image.programs.include? self
        image.image_type = banner.banner_type
        image.save! if image.changed?
        image
      end
    end
  end
end