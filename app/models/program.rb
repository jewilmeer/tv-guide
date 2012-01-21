# == Schema Information
# Schema version: 20110406203743
#
# Table name: programs
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  search_name        :string(255)
#  overview           :text
#  status             :string(255)
#  tvdb_id            :integer(4)
#  tvdb_last_update   :datetime
#  imdb_id            :string(255)
#  airs_dayofweek     :string(255)
#  airs_time          :string(255)
#  runtime            :integer(4)
#  network            :string(255)
#  contentrating      :string(255)
#  actors             :text
#  tvdb_rating        :integer(4)
#  last_checked_at    :datetime
#  time_zone_offset   :string(255)     default("Central Time (US & Canada)")
#  max_season_nr      :integer(4)      default(1)
#  current_season_nr  :integer(4)      default(1)
#  tvdb_name          :string(255)
#  fanart_image_id    :integer(4)
#  poster_image_id    :integer(4)
#  season_image_id    :integer(4)
#  series_image_id    :integer(4)
#  users_count        :integer(4)      default(0)
#  interactions_count :integer(4)      default(0)
#

class Program < ActiveRecord::Base
  include Pacecar
  require 'open-uri'
  
  has_many :episodes#, :through => :seasons, :dependent => :destroy
  has_many :interactions, :dependent => :nullify
  has_many :program_preferences
  has_many :programs_users
  has_many :seasons, :dependent => :destroy
  
  has_many :users, :through => :program_preferences
  has_many :search_term_types, :through => :program_preferences, :uniq => true
  
  has_one :configuration, :dependent => :destroy
  
  has_and_belongs_to_many :images
  has_and_belongs_to_many :genres, :uniq => true
  
  belongs_to :series_image, :class_name => 'Image'
  belongs_to :fanart_image, :class_name => 'Image'
  
  validates :name, :presence => true, :uniqueness => true
  validates :tvdb_name, :presence => true, :if => :has_tvdb_connection?
  validates :tvdb_id, :uniqueness => true, :if => :has_tvdb_connection?
  
  before_validation :update_by_tvdb_id#, :on => :create
  after_create :enrich_data
  before_save :update_episodes#, :if => Proc.new {|p| p.name_changed? }
  
  scope :by_name, order('name ASC')
  scope :tvdb_id, select('id, tvdb_id')
  scope :last_updated, order('updated_at desc')
  
  attr_accessor :active_configuration, :banners, :banner, :tvdb_serie, :fetch_remote_information

  def self.search_program query
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
    self.banner.url
  end
  
  def airs_time
    read_attribute(:airs_time) || '9:00 PM'
  end
  
  def to_s
    self.name
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
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
  
  def tvdb_last_update
    @tvdb_last_update ||= created_at
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
    tvdb_episodes.map{|episode| self.episodes << Episode.from_tvdb( episode, self ) }
  end
  
  def tvdb_episodes(only_new=false)
    episodes = tvdb_client.get_all_episodes_by_id(self.tvdb_id)
    episodes = episodes.select{|episode| Episode.valid_season_or_episode_nr episode.season_number.to_i }
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
  
  def max_season_nr
    read_attribute(:max_season_nr) || set_max_season_nr
  end
  
  def set_max_season_nr
    write_attribute(:max_season_nr, self.episodes.by_season_nr(:desc).first.try(:season_nr))
  end

  def current_season_nr 
    @current_season_nr ||= set_current_season_nr
  end
  
  def set_current_season_nr
    write_attribute(:current_season_nr, self.episodes.last_aired.first.try(:season_nr) || 1)
  end

  def update_episode_counters
    set_max_season_nr && set_current_season_nr && save
  end

  # methods to control propagating remote information
  def fetch_remote_information= value
    @fetch_remote_information= value
  end
  def fetch_remote_information
    return true if @fetch_remote_information.nil?
    !!@fetch_remote_information
  end

  def enrich_data
    [:add_episodes, :get_images].map{|method| self.send(method) } if fetch_remote_information
  end

  def update_episodes
    episodes.all.map do |episode|
      episode.program_name = self.name
      episode.save!
    end
  end
end
