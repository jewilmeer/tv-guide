class Genre < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :programs, -> { uniq }

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }

  after_save { Genre.delay.update_program_state(self.id) }

  def update_program_state
    if active
      programs.map(&:update_active_state!)
    else
      programs.update_all(active: false)
    end
  end

  def self.update_program_state(id)
    genre = Genre.find(id)
    genre.update_program_state
  end
end
