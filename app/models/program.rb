# == Schema Information
# Schema version: 20110329213820
#
# Table name: programs
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  search_name         :string(255)
#  overview            :text
#  status              :string(255)
#  tvdb_id             :integer(4)
#  tvdb_last_update    :datetime
#  imdb_id             :string(255)
#  airs_dayofweek      :string(255)
#  airs_time           :string(255)
#  banner_file_name    :string(255)
#  banner_content_type :string(255)
#  banner_file_size    :integer(4)
#  banner_updated_at   :datetime
#  runtime             :integer(4)
#  genres              :string(255)
#  network             :string(255)
#  contentrating       :string(255)
#  actors              :text
#  tvdb_rating         :integer(4)
#  last_checked_at     :datetime
#  time_zone_offset    :string(255)     default("Central Time (US & Canada)")
#  max_season_nr       :integer(4)      default(1)
#  current_season_nr   :integer(4)      default(1)
#  tvdb_name           :string(255)
#

class Program < ActiveRecord::Base
  include Pacecar
  require 'open-uri'
  require 'tvdb'
  require 'aws/s3'
  
  has_and_belongs_to_many :genres, :uniq => true
  has_many :seasons, :dependent => :destroy
  has_many :episodes#, :through => :seasons, :dependent => :destroy
  has_many :program_updates, :dependent => :destroy
  has_many :interactions, :dependent => :nullify
  has_and_belongs_to_many :users, :uniq => true
  has_one :configuration, :dependent => :destroy
  has_and_belongs_to_many :images
  
  validates :name, :presence => true, :uniqueness => true
  validates :tvdb_name, :presence => true, :if => :has_tvdb_connection?
  validates :tvdb_id, :uniqueness => true, :if => :has_tvdb_connection?

  before_validation :update_by_tvdb_id, :on => :create
  after_create :add_episodes, :get_images

  scope :by_name, order('name ASC')
  scope :tvdb_id, select('id, tvdb_id')
  
  attr_accessor :active_configuration, :banners, :banner, :tvdb_serie
  # cattr_accessor :tvdb_client
  
  has_attached_file :banner, 
                    :processors     => [], 
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :s3_permissions => 'public-read',
                    :s3_protocol    => 'http',
                    :s3_headers     => { :content_type => 'application/octet-stream', :content_disposition => 'attachment' },
                    :bucket         => Rails.env.production? ? 'tv-guide' : 'tv-guide-dev',
                    :path           => ':attachment/:id/:style/:filename'
  
  # def self.tvdb_client
  #   @tvdb_client ||= TVdb::Client.new(APP_CONFIG[:thetvdb]['api_key'])
  # end
  # 
  # def self.tvdb_search(query, options = {})
  #   # setup tvdb wrapper client
  #   self.tvdb_client.search(query.downcase.humanize, options)
  # end

  def self.search(query)
    if query
      if %w(development test).include?(Rails.env)
        search_for(query , :on => [:name, :search_name, :overview]) 
      else
        where(['name ILIKE :query OR search_name ILIKE :query OR overview ILIKE :query', {:query => "%#{query}%"}])
      end
    else
      scoped
    end
  end

  def active_configuration
    Configuration.default( self.configuration.try(:filter_data) )
  end
  
  def banners
    @banners ||= self.class.tvdb_client.get_banners(self.tvdb_id)
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
  
  def filename
    "#{self.name.parameterize}-banner.jpg"
  end
  
  def get_banner
    return unless tvdb_banner_filename
    tmp_filepath = "tmp/#{self.name.parameterize}-banner-#{tvdb_banner_filename}"
    open(tvdb_banner_url) {|tmp_file| self.banner= tmp_file}
  end
    
  def banner_url
    AWS::S3::S3Object.url_for(self.banner.path, self.banner.bucket_name)
  end
  
  # def episode_list
  #   @episode_list ||= self.class.tvdb_client.get_episodes(self.tvdb_id)
  # end
  # 
  # def fill_search_term
  #   self.search_term     = self.name
  #   self.last_checked_at = Time.now
  # end
  # 
  # def retrieve_episodes(save = true)
  #   changes = changed? ? [{:program => self.changes}] : []
  #   self.episode_list.each do |tvdb_episode|
  #     tmp_changes = nil
  #     # season      = self.seasons.find_or_create_by_nr(tvdb_episode['SeasonNumber'])
  #     episode     = self.episodes.find_or_initialize_by_season_nr_and_nr(tvdb_episode['SeasonNumber'], tvdb_episode['EpisodeNumber']) do |e|
  #       e.program_id = self.id
  #     end
  #     episode.tvdb_info = tvdb_episode
  #     
  #     tmp_changes = {(episode.new_record? ? episode.season_and_episode : episode.id) => episode.changes} if episode.changed?
  #     if save
  #        changes << tmp_changes if episode.save && tmp_changes
  #     end
  #   end
  #   if save
  #     self.program_updates.create(:revision_data => changes) if changes.any?
  #   else
  #     self.program_updates.build(:revision_data => changes)
  #   end
  #   changes
  # end
  # 
  # def find_additional_info
  #   self.attributes       = tvdb_info.reject{|k,v| !self.attributes.keys.include?(k) }
  #   self.name             = tvdb_info['seriesname']
  #   self.tvdb_id          = tvdb_info['id']
  #   self.tvdb_last_update = Time.at(tvdb_info['lastupdated'].to_i)
  #   self.overview         = tvdb_info['overview'].force_encoding("utf-8") if tvdb_info['overview']
  #   self.genres           = tvdb_info['genre']
  #   self.tvdb_rating      = tvdb_info['rating']
  #   self
  # end
  # 
  # def needs_update?
  #   return true if !self.last_checked_at || (self.last_checked_at + 1.hour).past?
  # end
  # 
  # def tvdb_info
  #   tvdb_id     ||= read_attribute(:tvdb_id) || get_tvdb_id
  #   @tvdb_info  ||= self.class.tvdb_client.get_program_info(tvdb_id).inject({}){|sum,item| sum[item.first.downcase]= item.last; sum }
  # end
  # 
  # def get_tvdb_id
  #   self.class.tvdb_search(self.name, :match_mode => :exact).first['seriesid']
  # end
  # 
  # def tvdb_update
  #   self.find_additional_info
  #   # changed?
  #   # needs_update? && 
  #   retrieve_episodes
  #   self.last_checked_at = Time.now
  #   self.save!
  # end
  
  def airs_time
    read_attribute(:airs_time) || '9:00 PM'
  end
  
  def to_s
    self.name
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
    
  def find_episode_information(episode_key)
    season, episode = Episode.episode_season_split(episode_key)
    episode         = self.episodes.season_episode_matches( season, episode ).first
    # episode.title if episode
  end
  
  def actors
    @actors ||= read_attribute(:actors) || []
    @actors.split('|').compact.reject(&:blank?)
  end
    
  # tvdb_party implementation
  # validates
  def has_tvdb_connection?
    tvdb_id.present?
  end
  
  def self.tvdb_client
    TvdbParty::Search.new(TVDB_API)
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
  
  def self.tvdb_search query
    tvdb_client.search( query ).map{|r| self.from_tvdb(r) }
  end
  
  def self.from_tvdb( tvdb_result )
    self.new.apply_tvdb_attributes tvdb_result
  end
  
  def tvdb_serie
    @tvdb_serie ||= tvdb_client.get_series_by_id self.tvdb_id
  end
  
  def apply_tvdb_attributes tvdb_result
    self.tvdb_serie     = tvdb_result #cache the object
    self.tvdb_id        = tvdb_result.id
    self.name           = self.search_name = self.tvdb_name = tvdb_result.name
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
    result = tvdb_client.get_series_by_id self.tvdb_id
    apply_tvdb_attributes result 
  end
  
  def self.tvdb_ids
    @tvdb_ids ||= self.tvdb_id.all
  end
  
  def self.updates timestamp=Time.now.to_i, only_existing=true
    result = tvdb_client.get_series_updates( timestamp )['Series']
    result.reject{|tvdb_id| !tvdb_ids.include?(tvdb_id.to_s) } if result && only_existing
  end

  # get new episodes, skip those specials and filter the ones already on the website
  def new_episodes
    tvdb_episodes(true)
  end
  
  def add_episodes
    tvdb_episodes.map{|episode| self.episodes << Episode.from_tvdb( episode ) }
  end
  
  def tvdb_episodes(only_new=false)
    episodes = tvdb_client.get_all_episodes_by_id(self.tvdb_id).reject{|episode| episode.season_number.to_i == 0 || episode.number.to_i == 0}
    if only_new 
      all_tvdb_ids = self.episodes.tvdb_id.all.map(&:tvdb_id)
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
      logger.debug "#{episode.full_episode_title}: #{episode.changed? ? episode.save : false}" 
    end
  end
  
  def get_images
    current_image_urls = images.url.map(&:url)
    tvdb_serie.banners.reject{|banner| current_image_urls.include?(banner.url) || banner.url.blank? }.map do |banner| 
      self.images.create( :url => banner.url, :image_type => banner.banner_type )
    end
  end
  
  def max_season_nr
    @max_season_nr ||= self.episodes.by_season_nr(:desc).first.season_nr
  end
  
  def current_season_nr 
    @current_season_nr ||= self.episodes.last_aired.first.try(:season_nr) || 1
  end
  
  def update_episode_counters
    max_season_nr && current_season_nr
  end
end
