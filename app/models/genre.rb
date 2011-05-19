# == Schema Information
# Schema version: 20110329213820
#
# Table name: genres
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Genre < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  has_and_belongs_to_many :programs, :uniq => true
end
