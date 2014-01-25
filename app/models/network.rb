class Network < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :programs

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }

  validates :name, presence: true

  after_save { Network.delay.update_program_state(self.id) }

  def update_program_state
    if active
      programs.map(&:update_active_state!)
    else
      programs.update_all(active: false)
    end
  end

  def self.update_program_state(id)
    genre = Network.find(id)
    genre.update_program_state
  end
end
