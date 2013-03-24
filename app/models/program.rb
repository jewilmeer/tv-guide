class Program < ActiveRecord::Base
  require 'open-uri'

  include Concerns::TVDB

  has_many :episodes
  has_many :interactions, :dependent => :nullify
  has_many :program_preferences
  has_many :programs_users
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

  before_validation :update_by_tvdb_id
  after_create :enrich_data, if: ->(program){ program.tvdb_id.present? }
  before_save :update_episodes_with_program_name

  scope :by_name, order('name ASC')
  scope :tvdb_id, select('id, tvdb_id')
  scope :last_updated, order('updated_at desc')

  attr_accessor :active_configuration, :banners, :banner, :tvdb_serie, :fetch_remote_information

  def self.search_program query
    query = "%#{query}%"
    where{ (name.matches query) | (search_name.matches query) | (overview.matches query) }
  end

  def active_configuration
    Configuration.default( self.configuration.try(:filter_data) )
  end

  def banners
    @banners ||= self.class.tvdb_client.get_banners(self.tvdb_id)
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

  def max_season_nr
    read_attribute(:max_season_nr) || set_max_season_nr
  end

  def set_max_season_nr
    write_attribute(:max_season_nr, self.episodes.order('season_nr desc').first.try(:season_nr))
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

  def enrich_data
    return true unless self.tvdb_id.present?
    [:add_episodes, :get_images].map{|method| self.send(method) } if fetch_remote_information
  end

  def update_episodes_with_program_name
    episodes.update_all program_name: self.name
  end
end

# == Schema Information
#
# Table name: programs
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  search_name               :string(255)
#  overview                  :text
#  status                    :string(255)
#  tvdb_id                   :integer
#  tvdb_last_update          :datetime
#  imdb_id                   :string(255)
#  airs_dayofweek            :string(255)
#  airs_time                 :string(255)
#  runtime                   :integer
#  network                   :string(255)
#  contentrating             :string(255)
#  actors                    :text
#  tvdb_rating               :integer
#  last_checked_at           :datetime
#  time_zone_offset          :string(255)      default("Central Time (US & Canada)")
#  max_season_nr             :integer          default(1)
#  current_season_nr         :integer          default(1)
#  tvdb_name                 :string(255)
#  fanart_image_id           :integer
#  poster_image_id           :integer
#  season_image_id           :integer
#  series_image_id           :integer
#  program_preferences_count :integer          default(0)
#  interactions_count        :integer          default(0)
#

