# == Schema Information
# Schema version: 20110415122530
#
# Table name: program_preferences
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  program_id          :integer(4)
#  download            :boolean(1)      default(TRUE)
#  search_term_type_id :integer(4)      default(1)
#  created_at          :datetime
#  updated_at          :datetime
#

class ProgramPreference < ActiveRecord::Base
  belongs_to :search_term_type
  belongs_to :user,     :counter_cache => :programs_count
  belongs_to :program,  :counter_cache => true

  validates :search_term_type_id, :presence => true
  validates :user_id,             :presence => true
  validates :program_id,          :presence => true, :uniqueness => {:scope => :user_id}

  scope :with_program, lambda{|program| where('program_id=?', program.id) }

  attr_accessor :q
end
