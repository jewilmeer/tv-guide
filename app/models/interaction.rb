# == Schema Information
# Schema version: 20101130174533
#
# Table name: interactions
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  episode_id       :integer(4)
#  program_id       :integer(4)
#  format           :string(255)     default("nzb")
#  interaction_type :string(255)
#  end_point        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Interaction < ActiveRecord::Base
  include Pacecar
  
  belongs_to :user, :touch => true, :counter_cache => true
  belongs_to :episode, :touch => true
  belongs_to :program, :touch => true, :counter_cache => true

  validates :interaction_type, :presence => true
  validates :format, :presence => true
  
  scope :interaction_type_is, lambda{|interaction_type| where('interaction_type = ?', interaction_type) }
end
