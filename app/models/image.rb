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