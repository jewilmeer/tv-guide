class Interaction < ActiveRecord::Base
  include Pacecar
  
  belongs_to :user
  belongs_to :episode
  belongs_to :program

  validates :interaction_type, :presence => true
  validates :format, :presence => true
  
  scope :interaction_type_is, lambda{|interaction_type| {:conditions => ['interaction_type = ?', interaction_type]} }
end