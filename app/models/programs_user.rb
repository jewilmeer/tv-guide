# == Schema Information
#
# Table name: programs_users
#
#  program_id :integer
#  user_id    :integer
#

class ProgramsUser < ActiveRecord::Base
  belongs_to :program#, :counter_cache => :users_count
  belongs_to :user#, :counter_cache => :programs_count
  
  validates :user_id, :uniqueness => {:scope => [:program_id]}
  
  after_create :increment_counters
  after_destroy :decrement_counters
  
  private
  def increment_counters
    Program.increment_counter 'users_count', program_id
    User.increment_counter 'programs_count', user_id
  end
  
  def decrement_counters
    Program.decrement_counter 'users_count', program_id
    User.decrement_counter 'programs_count', user_id
  end
end
