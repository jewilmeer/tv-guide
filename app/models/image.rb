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
  has_one :episode

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
  after_save :touch_episode
  attr_accessor :should_save

  has_attached_file :image,
    :bucket             => Proc.new { Image.s3_bucket },
    :default_style      => :original,
    :path               => "tvdb_images/:id/:style_:timestamp.jpg",
    :s3_credentials     => Rails.root.join("config/s3.yml"),
    :s3_headers         => { 'Expires' => 1.year.from_now.httpdate },
    :s3_host_alias      => Proc.new { Image.s3_host_alias },
    :s3_permissions     => 'public-read',
    :storage            => 's3',
    :styles             => { :banner => "642x220#", :thumb => "100x100>", :slide => '655x368>', :episode => '300x180^', :mini_episode => '140x80#' },
    :url                => ':s3_alias_url'
  
  def filename
    "image.jpg"
  end
  
  def save_image
    require 'open-uri'
    open(url, "r:UTF-8") {|tmp_file| self.image= tmp_file}
  end

  def s3_url(image_format = 'banner')
    unless image?
      save_image 
      save!
    end
    image.url(image_format).gsub('https', 'http')
  end
  
  def self.from_tvdb( result )
    find_or_initialize_by_url( result.url, {:image_type => result.banner_type})
  end

  def self.update_all_images(id_to_start = 10_000)
    # no limit to just a few
    scope = self.order('id desc').saved.where( 'id < ?', id_to_start)
    puts "found: #{scope.count} images"
    scope.each do |image|
      puts "id: #{image.id}"
      image.update_image
    end
  end

  def self.update_these ids
    all( ids ).each do |image|
      update_image
    end
  end

  def update_image
    if image
      save_image 
      save
    end
  end

  def self.purge_s3
    update_all ["
      image_file_name = NULL,
      image_content_type = NULL,
      image_file_size = NULL,
      image_updated_at = NULL"
    ]
  end

  private
  def touch_episode
    episode.touch if episode
  end

  def self.s3_bucket
    case Rails.env
    when 'production'
      'tv-guide'
    else
      'tv-guide-dev'
    end
  end

  def self.s3_host_alias
    case Rails.env
    when 'production'
      'images.jewilmeer.com'
    else
      'dev-images.jewilmeer.com'      
    end
  end
end
