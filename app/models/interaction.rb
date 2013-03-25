class Interaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :episode
  belongs_to :program

  validates :interaction_type, :presence => true
  validates :format, :presence => true

  scope :interaction_type_is, lambda{|interaction_type| where('interaction_type = ?', interaction_type) }
end

# == Schema Information
#
# Table name: interactions
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  episode_id       :integer
#  program_id       :integer
#  format           :string(255)      default("nzb")
#  interaction_type :string(255)
#  end_point        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  user_agent       :string(255)
#  referer          :string(255)
#

