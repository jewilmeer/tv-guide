class Program < ActiveRecord::Base
  require 'open-uri'

  include Concerns::TVDB

  has_many :episodes
  has_many :interactions, :dependent => :nullify
  has_many :program_preferences
  has_many :programs_users
  has_many :users, :through => :program_preferences
  has_many :search_term_types, :through => :program_preferences, :uniq => true

  has_and_belongs_to_many :images
  has_and_belongs_to_many :genres, :uniq => true

  belongs_to :series_image, :class_name => 'Image'
  belongs_to :fanart_image, :class_name => 'Image'

  validates :tvdb_id, :uniqueness => true

  before_save :update_episodes_with_program_name

  scope :by_name, order('name ASC')
  scope :last_updated, order('updated_at desc')

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
    "#{id}-#{name.parameterize}"
  end

  def update_episodes_with_program_name
    episodes.update_all program_name: self.name
  end

  def self.default_search_term_pattern
    "%{program_name} %{season_nr} %{filled_episode_nr}"
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