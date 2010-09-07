class ProgramUpdate < ActiveRecord::Base
  include Pacecar
  belongs_to :program
  serialize :revision_data
  serialize :parsed_data
  before_save :parse_update
  validates :revision_data, :presence => true

  scope :real_updates, {:conditions => ['LENGTH(parsed_data) > 8']}
  
  def updates
    all_updates = self.revision_data.reject{|u| !u.first.first.is_a?(Fixnum) }
    real_updates = {}
    all_updates.each do |episode|
      episode.each do |id, changed_attrs| 
        real_changes = {}
        changed_attrs.each do |attr, changes|
          real_changes[attr] = changes unless changes.first == changes.last
        end.flatten.compact
        real_updates[id] = real_changes if real_changes.any?
      end
    end
    real_updates
  end
  
  def additions
    self.revision_data.reject{|u| !u.first.first.to_s.match(/S\d{1,2}E\d{1,2}/) }
  end
  
  def program_update
    u = self.revision_data.detect{|u| u.first.first == :program}
    (u && u[:program] && !u[:program].nil?) ? u[:program] : {}
  end
  
  def updated_program_attributes
    @updated_program_attributes ||= program_update.reject{|k,v| k == 'tvdb_last_update' }   
  end
  
  def real_updates
    real_updates = {}
    real_updates[:program]   = self.updated_program_attributes if self.updated_program_attributes.any?
    real_updates[:additions] = self.additions if self.additions.any?
    real_updates[:updates]   = self.updates if self.updates.any?
    real_updates
  end
  
  def parse_update
    self.parsed_data = self.real_updates
  end
end