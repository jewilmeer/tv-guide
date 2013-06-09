class Station < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slugish, use: :slugged

  belongs_to :user
  belongs_to :taggable, polymorphic: true

  has_many :station_programs
  has_and_belongs_to_many :programs
  has_many :episodes, through: :programs

  validates :name, presence: true

  scope :user_stations,   -> { where( taggable_type: "User") }
  scope :genre_stations,  -> { where( taggable_type: "Genre") }
  scope :personal,        -> { user_stations.where( 'stations.user_id = stations.taggable_id' ) }

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

# == Schema Information
#
# Table name: stations
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  user_id       :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#  slug          :string(255)
#