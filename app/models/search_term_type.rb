class SearchTermType < ActiveRecord::Base
  has_many :program_preferences
  has_many :downloads, :foreign_key => :download_type, :primary_key => :code

  validates :name, :presence => true, :uniqueness => true
  validates :code, :presence => true, :uniqueness => true

  cattr_accessor :default

  scope :with_program, lambda{|program| where('program_id', program.id) }

  def self.default
    @default ||= self.find_by_code('hd')
  end
end

# == Schema Information
#
# Table name: search_term_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  search_term :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

