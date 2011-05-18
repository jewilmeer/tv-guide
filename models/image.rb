# == Schema Information
# Schema version: 20110401104841
#
# Table name: images
#
#  id                 :integer(4)      not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  url                :string(255)
#  image_type         :string(255)
#  downloaded         :boolean(1)
#

class Image < ActiveRecord::Base
  
  has_and_belongs_to_many :programs, :uniq => true
  
  validates :url, :uniqueness => true

  scope :image_type,  lambda{|type| where('images.image_type = ?', type)}
  scope :fanart,      where('images.image_type = ?', 'fanart')
  scope :series,      where('images.image_type = ?', 'series')
  scope :url,         select('images.id, images.url')
  scope :only_id,     select('images.id')
  scope :random,      lambda{ Rails.env.production? ? order('RANDOM()') : order('RAND()') }
  scope :distinctly,  lambda{|columns| select("DISTINCT #{columns}") }
  scope :saved,       where('image_file_name IS NOT NULL')
  
  before_save :save_image, :if => Proc.new{|i| i.url.present? && i.should_save == true }
  
  attr_accessor :should_save
  
  has_attached_file :image,
    :styles => { :banner => "642x220#", :thumb => "100x100>", :slide => '655x368>', :episode => '300x180^', :mini_episode => '140x80#' },
    :storage        => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :s3_permissions => 'public-read',
    :s3_protocol    => 'http',
    :bucket         => Rails.env.production? ? 'tv-guide' : 'tv-guide-dev',
    :path           => ':attachment/:id/:style/:filename'
    
  def filename
    "image.jpg"
  end
  
  def save_image
    require 'open-uri'
    open(url) {|tmp_file| self.image= tmp_file}
  end

  def s3_url(image_format = 'banner')
    unless image?
      save_image 
      save
    end
    AWS::S3::S3Object.url_for(self.image.path(image_format), self.image.bucket_name)
  end
  
  def self.from_tvdb( result )
    find_or_initialize_by_url( result.url, {:image_type => result.banner_type})
  end
end
