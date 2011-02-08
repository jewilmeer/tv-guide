# == Schema Information
# Schema version: 20101130174533
#
# Table name: episodes
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  nr          :integer(4)
#  airdate     :date
#  season_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  program_id  :integer(4)
#  airs_at     :datetime
#

class Episode < ActiveRecord::Base
  include Pacecar
  include ActionView::Helpers::SanitizeHelper
  
  belongs_to :season
  belongs_to :program, :touch => true
  has_and_belongs_to_many :users
  has_many :interactions, :dependent => :nullify
  has_many :downloads, :dependent => :destroy
  
  validates :title, :season_id, :program_id, :presence => true
  validates :nr, :presence => true, :uniqueness => {:scope => [:season_id, :program_id]}
  
  scope :downloaded, includes(:downloads).where('downloads.id IS NOT NULL')
  scope :season_episode_matches, lambda{|season, episode| {:include => :season, :conditions => ['episodes.nr = :episode AND seasons.nr = :season ', {:episode => episode, :season => season}] } }
  # scope :watched_by_user, lambda{|programs| {:conditions => ['program_id IN (?)', programs.map(&:id)] }}
  scope :no_downloads_present, includes(:downloads).where('downloads.id IS NULL')
  scope :next_airing, airs_at_in_future.order('episodes.airs_at asc')
  scope :last_aired, airs_at_in_past.order('episodes.airs_at desc')
  
  before_save :airs_at
  before_update :update_airs_at
  
  attr_accessor :options, :name, :episode, :filters, :real_filename
  
  has_attached_file :nzb, 
                    :processors => [], 
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :s3_permissions => 'authenticated-read',
                    :s3_protocol => 'http',
                    :s3_headers => { :content_type => 'application/octet-stream', :content_disposition => 'attachment' },
                    :bucket => Rails.env.production? ? 'us-nzbs' : 'tmp-nzbs',
                    :path => ':attachment/:id/:style/:filename.nzb'
  
  def <=>(o)
    program_comp = self.program.name <=> o.program.name
    return program_comp unless program_comp == 0

    season_comp = self.season.to_i <=> o.season.to_i
    return season_comp unless season_comp == 0

    episode_comp = self.episode <=> o.episode
    return episode_comp #unless int_comp == 0
  end
  
  def self.episode_season_split(q)
    match = q.match(/S(\d{1,2})E(\d{1,2})/)
    [ match[1].to_i, match[2].to_i ] if match && match.length == 3
  end
    
  def episode
    "%02d" % nr.to_i
  end
  
  def match(pattern)
    match = filename.match(Regexp.new(pattern, 'i'))
    match ? match[1] : nil
  end
  
  def is_episode?
    %w(.avi .mkv .mov .srt .wmv .ts).include?(File.extname(path).downcase)
  end
  
  def age
    logger.debug "airs_at: #{airs_at.inspect}"
    0 unless airs_at
    (airs_at.to_date - Date.today).to_i.abs.succ
  end

  def search_url(hd = false)
    program.active_configuration.search_url(search_query(hd), {:age => self.age})
  end
  
  def search_query(hd)
    terms = []
    terms << program.search_term << season_and_episode 
    terms << program.active_configuration.hd_terms if hd
    terms * ' '
  end
  
  def season_and_episode
    "S#{"%02d" % season.to_i}E#{episode}"
  end
  
  def full_episode_title
    "#{season_and_episode} - #{title}"
  end
  
  def filename
    "#{program.name}_#{season_and_episode}_-_#{title}".parameterize
  end

  def renamed_filename
    renamed = season_and_episode
    renamed << " - #{title}" if title && !title.empty?
    renamed.gsub!(/[^a-z0-9\-_\+]+/i, '_')
    renamed << ( filename ? File.extname(filename) : '.mkv' )
  end

  def filters
    @filters || APP_CONFIG[:filters].split(/ /)
  end
  
  def to_s
    renamed_filename || filename
  end
    
  def to_i
    nr.to_i
  end
  
  def self.to_i(season, filename)
    match = filename.match(Regexp.new("[#{season.to_i}]{1,2}[Ex]*(\\d{1,2})", Regexp::IGNORECASE))
    match ? match[1].to_i : nil
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def get_nzb( options = {} )
    default_options = {
      :format => :nzb,
      :hd => true
    }
    options       = default_options.merge(options)
    download_type = "#{options[:format]}_#{options[:hd] ? 'hd' : 'sd'}"

    logger.debug "Getting nzbfile from #{search_url}"
    tmp_filepath = "tmp/#{filename}.nzb"
    agent        = Browser.agent

    download = self.downloads.find_or_initialize_by_download_type(download_type)
    
    # nzbindex
    next_page   = agent.get(search_url(true)).forms.last.submit
    if (download_links = next_page.links_with(:text => 'Download')).any?
      download.origin = strip_tags(Nokogiri::HTML(next_page.body).css('td label').last.to_s)
      file            = download_links.last.click#.save(tmp_filepath)
      download.file   = file
      download.site   = 'nzbindex.nl'
      download.save
    else
      logger.debug "No downloads found at #{search_url(true)}"
      false
    end

    # newzleech
    # file = agent.get( search_url(true) ).links_with(:href => /\?m=gen/).last.click.save(tmp_filepath)
    
    # 
    # TODO ADD THE DOWNLOAD AT THE RIGHT PLACE
    # 
    
    # return 'failed to download' unless file
    # 
    # File.open(tmp_filepath) {|nzb_file| self.nzb = nzb_file  }
    # return 'failed to download (empty file)' unless self.nzb.size > 0
    # self.save
    # File.delete(tmp_filepath)
  end
  
  def tvdb_info=(tvdb_info)
    self.title       = tvdb_info['EpisodeName']
    self.nr          = tvdb_info['EpisodeNumber']
    self.description = tvdb_info['Overview'] ? tvdb_info['Overview'].force_encoding('utf-8') : nil
    self.airdate     = tvdb_info['FirstAired'] ? Date.parse(tvdb_info['FirstAired']) : nil
  end
    
  def self.from_tvdb tvdb_hash
    self.new({
      :title       => tvdb_hash['EpisodeName'],
      :nr          => tvdb_hash['EpisodeNumber'],
      :description => tvdb_hash['Overview'] ? tvdb_hash['Overview'].force_encoding('utf-8') : nil, 
      :airdate     => Date.parse(tvdb_hash['FirstAired'])
    })
  end
  
  def update_airs_at(forced=false)
    if airdate
      self.airs_at = Time.zone.parse( self.airdate.to_s(:db) + ' ' + self.program.airs_time + '-6' )
    else
      self.airs_at = nil 
    end
  end
  
  def airs_at
    @airs_at ||= read_attribute(:airs_at) || Time.zone.parse( self.airdate.to_s(:db) + ' ' + self.program.airs_time + '-6' )
  rescue StandardError => e
    logger.debug "airs_at error: #{e}"
    nil
  end
  
  def working?
    last_blame = self.interactions.interaction_type_is('blame').last
    return true unless last_blame
    false
  end
  
  def self.watched_by_user(program_ids)
    where('episodes.program_id IN (?)', program_ids)
  end
end
