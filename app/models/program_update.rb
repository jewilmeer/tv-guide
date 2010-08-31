class ProgramUpdate < ActiveRecord::Base
  belongs_to :program
  serialize :revision_data
  
  validates :revision_data, :presence => true
end