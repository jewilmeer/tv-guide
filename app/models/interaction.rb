class Interaction < ActiveRecord::Base
  include Pacecar
  
  belongs_to :user
  belongs_to :episode
  belongs_to :program

  validates :interaction_type, :presence => true
  validates :format, :presence => true
end