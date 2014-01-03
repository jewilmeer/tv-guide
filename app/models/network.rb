class Network < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :programs

  validates :name, presence: true
end
