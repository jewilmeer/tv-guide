# == Schema Information
# Schema version: 20101130174533
#
# Table name: programs
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  search_term         :string(255)
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
#

class Program < ActiveRecord::Base
  include Pacecar
  require 'open-uri'
  require 'tvdb'
  require 'aws/s3'
  
  has_many :seasons, :dependent => :destroy
  has_many :episodes, :through => :seasons, :dependent => :destroy
  has_many :program_updates, :dependent => :destroy
  has_many :interactions, :dependent => :nullify
  has_and_belongs_to_many :users, :uniq => true
  has_one :configuration, :dependent => :destroy
  has_and_belongs_to_many :images
  
  validates :name, :presence => true, :uniqueness => true
  # before_validation :guess_correct_name, :on => :create
  before_create :find_additional_info, :fill_search_term, :get_banner
  after_create :retrieve_episodes

  scope :by_name, :order => 'name ASC'
  
  attr_accessor :active_configuration, :banners, :banner
  cattr_accessor :tvdb_client
  
  has_attached_file :banner, 
                    :processors     => [], 
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :s3_permissions => 'public-read',
                    :s3_protocol    => 'http',
                    :s3_headers     => { :content_type => 'application/octet-stream', :content_disposition => 'attachment' },
                    :bucket         => Rails.env.production? ? 'tv-guide' : 'tv-guide-dev',
                    :path           => ':attachment/:id/:style/:filename'
  
  def self.tvdb_client
    @tvdb_client ||= TVdb::Client.new(APP_CONFIG[:thetvdb]['api_key'])
  end
  
  def self.tvdb_search(query, options = {})
    # setup tvdb wrapper client
    self.tvdb_client.search(query.downcase.humanize, options)
  end

  def self.search(query)
    if query
      if %w(development test).include?(Rails.env)
        search_for(query , :on => [:name, :search_term, :overview]) 
      else
        where(['name ILIKE :query OR search_term ILIKE :query OR overview ILIKE :query', {:query => "%#{query}%"}])
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
    return false unless tvdb_banner_filename
    tmp_filepath = "tmp/#{self.name.parameterize}-banner-#{tvdb_banner_filename}"
    open(tvdb_banner_url) {|tmp_file| self.banner= tmp_file}
  end
    
  def banner_url
    AWS::S3::S3Object.url_for(self.banner.path, self.banner.bucket_name)
  end
  
  def episode_list
    @episode_list ||= self.class.tvdb_client.get_episodes(self.tvdb_id)
  end
  
  def fill_search_term
    self.search_term     = self.name
    self.last_checked_at = Time.now
  end
  
  def retrieve_episodes(save = true)
    changes = changed? ? [{:program => self.changes}] : []
    self.episode_list.each do |tvdb_episode|
      tmp_changes = nil
      season      = self.seasons.find_or_create_by_nr(tvdb_episode['SeasonNumber'])
      episode     = season.episodes.find_or_initialize_by_nr(tvdb_episode['EpisodeNumber']) do |e|
        e.program_id = self.id
      end
      episode.tvdb_info = tvdb_episode
      
      tmp_changes = {(episode.new_record? ? episode.season_and_episode : episode.id) => episode.changes} if episode.changed?
      if save
         changes << tmp_changes if episode.save && tmp_changes
      end
    end
    if save
      self.program_updates.create(:revision_data => changes) if changes.any?
    else
      self.program_updates.build(:revision_data => changes)
    end
    changes
  end

  def find_additional_info
    self.attributes       = tvdb_info.reject{|k,v| !self.attributes.keys.include?(k) }
    self.name             = tvdb_info['seriesname']
    self.tvdb_id          = tvdb_info['id']
    self.tvdb_last_update = Time.at(tvdb_info['lastupdated'].to_i)
    self.overview         = tvdb_info['overview'].force_encoding("utf-8") if tvdb_info['overview']
    self.genres           = tvdb_info['genre']
    self.tvdb_rating      = tvdb_info['rating']
    self
  end
  
  def needs_update?
    return true if !self.last_checked_at || (self.last_checked_at + 1.hour).past?
  end
  
  def tvdb_info
    tvdb_id     ||= read_attribute(:tvdb_id) || get_tvdb_id
    @tvdb_info  ||= self.class.tvdb_client.get_program_info(tvdb_id).inject({}){|sum,item| sum[item.first.downcase]= item.last; sum }
  end
  
  def get_tvdb_id
    self.class.tvdb_search(self.name, :match_mode => :exact).first['seriesid']
  end
  
  def tvdb_update
    self.find_additional_info
    # changed?
    # needs_update? && 
    retrieve_episodes
    self.last_checked_at = Time.now
    self.save!
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
    
  def find_episode_information(episode_key)
    season, episode = Episode.episode_season_split(episode_key)
    episode         = self.episodes.season_episode_matches( season, episode ).first
    # episode.title if episode
  end
  
  def actors
    @actors ||= read_attribute(:actors) || []
    @actors.split('|').compact.reject(&:blank?)
  end
  
  def genres
    @genres ||= read_attribute(:genres) || []
    @genres.split('|').compact.reject(&:blank?)
  end
end
