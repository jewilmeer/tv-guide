class Station < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slugish, use: :slugged

  belongs_to :user
  belongs_to :taggable, polymorphic: true

  has_many :station_programs
  has_many :programs, through: :station_programs
  has_many :episodes, through: :programs

  validates :name, presence: true

  scope :user_stations,   -> { where( taggable_type: "User") }
  scope :genre_stations,  -> { where( taggable_type: "Genre") }
  scope :personal,        -> { user_stations.where( 'stations.user_id = stations.taggable_id' ) }
  scope :filled,          -> { where("id in (SELECT DISTINCT ON (program_id) station_id id FROM programs_stations)") }

  def url_params
    { station_type: taggable_type, station_id: taggable_id }
  end

  def slugish
    case taggable
    when Genre
      "#{taggable_type.downcase}_#{taggable.name}"
    when User
      user.login
    else
      raise 'Go eat your own fish, we are not finished yet'
    end
  end
end
