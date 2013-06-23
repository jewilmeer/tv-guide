class Image < ActiveRecord::Base
  mount_uploader :file, ::ImageUploader

  belongs_to :program

  validates :source_url, presence: true

  scope :downloaded,      ->{ where( arel_table[:file].not_eq(nil) ) }
  scope :with_image_type, ->(image_type) { where( image_type: image_type ) }
  scope :with_fanart,     ->{ where( 'image_type IN (?)', %w(fanart:1920x1080 fanart:1280x720) ) }

  after_create ->(image) { image.delay.download }

  def download
    self.remote_file_url = self.source_url
    self.save
  end
end
# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  source_url :string(255)
#  image_type :string(255)
#  downloaded :boolean          default(FALSE)
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

