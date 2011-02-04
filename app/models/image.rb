# == Schema Information
# Schema version: 20101130174533
#
# Table name: images
#
#  id                 :integer(4)      not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  string             :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class Image < ActiveRecord::Base
  
  has_and_belongs_to_many :programs
  
  has_attached_file :image,
    :styles => { :banner => "642x220#", :thumb => "100x100>" },
    :storage        => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :s3_permissions => 'public-read',
    :s3_protocol    => 'http',
    :bucket         => Rails.env.production? ? 'tv-guide' : 'tv-guide-dev',
    :path           => ':attachment/:id/:style/:filename'
    
  def filename
    "image.jpg"
  end
end
