class Station < ActiveRecord::Base
  belongs_to :user
  belongs_to :taggable, polymorphic: true

  has_and_belongs_to_many :programs
  has_many :episodes, through: :programs

  validates :name, presence: true

  scope :personal, ->(){ where( taggable_type: 'User', user_id: :taggable_id ) }
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
#