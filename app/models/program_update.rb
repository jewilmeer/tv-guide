class ProgramUpdate < ActiveRecord::Base
  include Pacecar
  belongs_to :program
  serialize :revision_data
  
  validates :revision_data, :presence => true
  
  def updates
    self.revision_data.reject{|u| !u.first.first.is_a?(Fixnum) }
  end
  
  def additions
    self.revision_data.reject{|u| u.first.first.is_a?(Fixnum) }
  end
end