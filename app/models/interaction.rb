class Interaction < ActiveRecord::Base
  include Pacecar
  
  belongs_to :user, :touch => true
  belongs_to :episode, :touch => true
  belongs_to :program, :touch => true

  validates :interaction_type, :presence => true
  validates :format, :presence => true
  
  scope :interaction_type_is, lambda{|interaction_type| where('interaction_type = ?', interaction_type) }
end