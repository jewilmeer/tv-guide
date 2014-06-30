class Download < ActiveRecord::Base
  belongs_to :episode, touch: true

  has_attached_file :download,
    processors: [],
    storage:        :s3,
    s3_credentials: Rails.application.secrets.aws,
    s3_permissions: :private,
    s3_protocol:    'http',
    s3_headers:     {
      content_type: 'application/octet-stream',
      content_disposition: 'attachment'
    },
    bucket:         Rails.env.production? ? 'tv-guide' : 'tv-guide-dev',
    path:           ':attachment/:id/:style/:filename.nzb'

  do_not_validate_attachment_file_type :download
  validates_attachment :download,
    presence: true,
    content_type: { content_type: "application/xml" },
    file_name: { matches: /.*/ }
  validates_attachment_content_type :download, content_type: 'application/xml'
  validates :origin, :download_type, presence: true
  validates :download_type, uniqueness: { scope: [:episode_id] }

  def filename
    episode.filename
  end

  def file=(file)
    tmp_filepath = "tmp/#{filename}.nzb"
    file.save(tmp_filepath)
    File.open(tmp_filepath, "r:UTF-8") do |nzb_file|
      self.download = nzb_file
    end
    File.delete(tmp_filepath)
  end
end
# == Schema Information
#
# Table name: downloads
#
#  id                    :integer          not null, primary key
#  episode_id            :integer
#  download_type         :string(255)
#  download_file_name    :string(255)
#  download_content_type :string(255)
#  download_file_size    :integer
#  origin                :string(255)
#  site                  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

