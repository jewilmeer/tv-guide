# == Schema Information
# Schema version: 20101130174533
#
# Table name: downloads
#
#  id                    :integer(4)      not null, primary key
#  episode_id            :integer(4)
#  download_type         :string(255)
#  download_file_name    :string(255)
#  download_content_type :string(255)
#  download_file_size    :integer(4)
#  origin                :string(255)
#  site                  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Download < ActiveRecord::Base
  include Pacecar
  
  belongs_to :search_term_type, :foreign_key => 'download_type', :primary_key => 'code'
  belongs_to :episode
  
  validates_presence_of :origin, :site, :download_type, :download_file_name
  validate :download_type, :uniqueness => { :scope => [:episode_id, :origin] }
  
  has_attached_file :download,
    :processors => [], 
    :storage        => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :s3_permissions => 'public-read',
    :s3_protocol    => 'http',
    :s3_headers     => { :content_type => 'application/octet-stream', :content_disposition => 'attachment' },
    :bucket         => Rails.env.production? ? 'tv-guide' : 'tv-guide-dev',
    :path           => ':attachment/:id/:style/:filename.nzb'

  def filename
    episode.filename
  end
  
  def file=(file)
    tmp_filepath = "tmp/#{filename}.nzb"
    tmp_file     = file.save(tmp_filepath)
    File.open(tmp_filepath) do |nzb_file| 
      self.download = nzb_file  
    end
    File.delete(tmp_filepath)
  end
end
