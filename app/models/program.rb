class Program < ActiveRecord::Base
  require 'open-uri'

  include Concerns::TVDB

  has_many :episodes, :dependent => :destroy
  has_many :interactions, :dependent => :nullify
  has_many :station_programs, dependent: :destroy
  has_many :images, dependent: :destroy

  has_and_belongs_to_many :stations
  has_and_belongs_to_many :genres, :uniq => true

  validates :tvdb_id, :uniqueness => true
  validates :name, presence: true, if: :persisted?

  before_save :update_episodes_with_program_name

  scope :followed_by_any_user, -> { includes(:stations).where( 'stations.taggable_type'=> 'User') }

  def self.search_program query
    query = "%#{query}%"
    where{ (name.matches query) | (search_name.matches query) | (overview.matches query) }
  end

  def airs_time
    read_attribute(:airs_time) || '9:00 PM'
  end

  def to_s
    self.name
  end

  def to_param
    return "#{id}-#{name.parameterize}" if name.present?
    super
  end

  def update_episodes_with_program_name
    episodes.update_all program_name: self.name
  end

  def self.default_search_term_pattern
    "%{program_name} %{season_nr} %{filled_episode_nr}"
  end

  def followed_by_any_user?
    Program.followed_by_any_user.where(id: self.id).any?
  end

  def followed_by_user?(user)
    self.stations.user_stations.where('user_id = ?', user.id).any?
  end

  def banner
    self.images.with_fanart.sample
  end

  def series_banner
    self.images.with_image_type('series:graphical').all.sample
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
#  program_preferences_count :integer          default(0)
#

