class Interaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :episode
  belongs_to :program

  validates :interaction_type, :presence => true
  validates :format, :presence => true

  scope :interaction_type_is, ->(interaction_type) { where(interaction_type: interaction_type) }
end
