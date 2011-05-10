# == Schema Information
# Schema version: 20110415122530
#
# Table name: search_term_types
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  code        :string(255)
#  search_term :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class SearchTermType < ActiveRecord::Base
  include Pacecar
  
  has_many :program_preferences
  has_many :downloads, :foreign_key => :download_type, :primary_key => :code
  
  validates :name, :presence => true, :uniqueness => true
  
  cattr_accessor :default
  
  def self.default
    @default ||= self.find_by_code('hd')
  end
end
