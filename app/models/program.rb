class Program < ActiveRecord::Base
  require 'open-uri'

  include Concerns::TVDB
  include FriendlyId
  friendly_id :slug_candidates

  has_many :episodes, :dependent => :destroy
  has_many :interactions, :dependent => :nullify
  has_many :station_programs, dependent: :destroy
  has_many :images, dependent: :destroy

  has_many :stations, through: :station_programs
  has_and_belongs_to_many :genres

  validates :tvdb_id, :uniqueness => true
  validates :name, presence: true, if: :persisted?

  before_save :update_episodes_with_program_name

  scope :followed_by_any_user, -> { includes(:stations).where( 'stations.taggable_type'=> 'User') }

  def self.search_program query
    start_query, full_query = "%#{query}", "%#{query}%"
    order('status, name').
    where( %(programs.name LIKE :query OR programs.search_name LIKE :query OR overview LIKE :full_query),
      { query: query, full_query: full_query }
    )
  end

  def airs_time
    read_attribute(:airs_time) || '9:00 PM'
  end

  def to_s
    self.name
  end

  def update_episodes_with_program_name
    return unless persisted?
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

  def year_first_aired
    first_aired.year
  end

  def slug_candidates
    [
      :name,
      [:name, :year_first_aired],
      [:name, :tvdb_id]
    ]
  end

  def should_generate_new_friendly_id
    name_changed?
  end
end
