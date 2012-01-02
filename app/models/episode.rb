# == Schema Information
# Schema version: 20110518202259
#
# Table name: episodes
#
#  id               :integer(4)      not null, primary key
#  title            :string(255)
#  description      :text
#  path             :string(255)
#  nr               :integer(4)
#  airdate          :date
#  downloaded       :boolean(1)
#  watched          :boolean(1)
#  season_id        :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#  nzb_file_name    :string(255)
#  nzb_content_type :string(255)
#  nzb_file_size    :integer(4)
#  nzb_updated_at   :datetime
#  program_id       :integer(4)
#  airs_at          :datetime
#  downloads        :integer(4)      default(0)
#  season_nr        :integer(4)
#  tvdb_id          :integer(4)
#  program_name     :string(255)
#  tvdb_program_id  :integer(4)
#  image_id         :integer(4)
#

class Episode < ActiveRecord::Base
  include Pacecar
  include ActionView::Helpers::SanitizeHelper
    
  # belongs_to :season
  belongs_to :program#, :touch => true
  has_and_belongs_to_many :users
  has_many :interactions, :dependent => :nullify
  has_many :downloads, :dependent => :destroy
  belongs_to :image
  
  validates :title, :season_nr, :program_id, :presence => true
  validates :nr, :presence => true, :uniqueness => {:scope => [:season_nr, :program_id]}
  
  scope :downloaded,              includes(:downloads).where('downloads.id IS NOT NULL')
  scope :season_episode_matches,  lambda{|season, episode| {:conditions => ['episodes.nr = :episode AND episodes.season_nr = :season ', {:episode => episode, :season => season}] } }
  scope :no_downloads_present,    includes(:downloads).where('downloads.id IS NULL')
  scope :airs_at_in_future,       lambda{ where('episodes.airs_at > ?', Time.zone.now) }
  scope :airs_at_in_past,         lambda{ where('episodes.airs_at < ?', Time.zone.now) }
  scope :next_airing,             lambda{ airs_at_in_future.order('episodes.airs_at asc') }
  scope :last_aired,              lambda{ airs_at_in_past.order('episodes.airs_at desc') }
  scope :tvdb_id,                 select("id, tvdb_id")
  scope :random,                  lambda{ Rails.env.production? ? order('RANDOM()') : order('RAND()') }
  scope :distinct_program_id,     lambda{|additional_selects| select("DISTINCT episodes.program_id, #{additional_selects}") }
  scope :last_updated,            order('episodes.updated_at desc')

  attr_accessor :options, :name, :episode, :filters, :thumb
  
  before_validation :update_program_name
  before_save :touch_episode
    
  def <=>(o)
    program_comp = self.program.name <=> o.program.name
    return program_comp unless program_comp == 0

    season_comp = self.season_nr <=> o.season_nr
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
    0 unless airs_at
    (airs_at.to_date - Date.today).to_i.abs.succ
  end

  def search_url( search_term_type_code )
    stt = SearchTermType.find_by_code(search_term_type_code)
    extra_terms = stt.try(:search_term) || ''
    program.active_configuration.search_url( search_query(extra_terms), {:age => self.age})
  end
  
  def search_query(extra_terms)
    ([] << program.search_name << season_and_episode << extra_terms) * ' '
  end
  
  def program_name
    @program_name || program.try(:name)
  end
    
  def season_and_episode
    "S#{"%02d" % season_nr}E#{episode}"
  end
  
  def full_episode_title
    "#{season_and_episode} - #{title}"
  end
  
  def full_title
    "#{program_name} - #{full_episode_title}"
  end
  
  def filename
    "#{program_name}_#{season_and_episode}_-_#{title}".parameterize
  end

  def filters
    @filters || APP_CONFIG[:filters].split(/ /)
  end
  
  def to_s
    filename
  end
    
  def to_i
    nr.to_i
  end
  
  def self.to_i(season, filename)
    match = filename.match(Regexp.new("[#{season_nr}]{1,2}[Ex]*(\\d{1,2})", Regexp::IGNORECASE))
    match ? match[1].to_i : nil
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def download_types
    program.search_term_types
  end

  def download_all
    download_types.map{|dt| self.download dt}
  end

  def download search_term_type
    search_url = search_url( search_term_type.code )
    download   = downloads.find_or_initialize_by_download_type( search_term_type.code )

    logger.debug "Getting #{search_term_type.name} from #{search_url}"
    
    # nzbindex
    next_page   = Browser.agent.get( search_url ).forms.last.submit
    if (download_links = next_page.links_with(:text => 'Download')).any?
      download.origin = strip_tags(Nokogiri::HTML(next_page.body).css('td label').last.to_s)
      file            = download_links.last.click
      download.file   = file
      download.site   = 'nzbindex.nl'
      download.save
    else
      logger.debug "No downloads found at #{search_url}"
      false
    end
  end
  
  def get_nzb( options = {} )
    download_all
  end
  
  def airs_at=(airdate, forced=false)
    if airdate.present? && self.program.try(:airs_time)
      Time.zone = self.program.time_zone_offset
      write_attribute(:airs_at, Time.zone.parse( airdate.to_s(:db) + ' ' + self.program.airs_time ))
    else
      write_attribute(:airs_at, nil)
    end
  end
  
  def airs_at
    Time.zone = self.program.time_zone_offset
    @airs_at ||= read_attribute(:airs_at) || Time.zone.parse( self.airdate.to_s(:db) + ' ' + self.program.airs_time )
  rescue StandardError => e
    logger.debug "airs_at error: #{e}"
    nil
  end
  
  def thumb=url
    return false unless url.present?
    # remove existing link
    # self.image.try(:destroy)
    self.image = find_existing_image_by_url( url )
  end

  def find_existing_image_by_url url
    Image.find_or_initialize_by_url( url )
  end

  def thumb
    self.image || self.program.images.saved.fanart.random.first || (image = self.program.images.fanart.random.first; image.save_image; image.save; image)
  end
  
  def working?
    last_blame = self.interactions.interaction_type_is('blame').last
    return true unless last_blame
    false
  end
  
  def self.watched_by_user(program_ids)
    where('episodes.program_id IN (?)', program_ids)
  end
  
  # api methods
  def self.tvdb_client
    TvdbParty::Search.new(TVDB_API)
  end
  def tvdb_client
    self.class.tvdb_client
  end
  def apply_tvdb_attributes tvdb_result, _program=nil
    self.program      = _program if _program
    self.program_name = _program.name if _program
    self.program_name = program.name if program
    self.tvdb_id      = tvdb_result.id
    self.nr           = tvdb_result.number
    self.season_nr    = tvdb_result.season_number
    self.title        = tvdb_result.name || 'TBA'
    self.description  = tvdb_result.overview
    self.airdate      = tvdb_result.air_date
    self.airs_at      = tvdb_result.air_date
    self.thumb        = tvdb_result.try(:thumb)
    self
  end
  
  def self.from_tvdb tvdb_result, program=nil
    if program
      _new = self.new( :program_id => program.id )
    else
      _new = self.new
    end
    _new.apply_tvdb_attributes tvdb_result
  end
  
  def self.tvdb_ids
    @tvdb_ids ||= tvdb_id.all
  end
  
  def self.updates timestamp=Time.now, only_existing = true
    updates = tvdb_client.get_episodes_updates( timestamp.to_i )['Episode']
    only_existing ? updates.reject{|tvdb_id| !tvdb_ids.include?(tvdb_id.to_s) } : updates
  end
  
  def tvdb_update
    e = tvdb_client.get_episode_by_id self.tvdb_id
    self.apply_tvdb_attributes e 
    save
  end
  def self.get_episodes_by_tvdb_id tvdb_id
    tvdb_client.get_all_episodes_by_id( tvdb_id ).reject{|e| e.season_number.to_i == 0}
  end

  def update_program_name
    program_name = program.name if program
  end

  def touch_episode
    program.touch unless program_name_changed?
  end

  def self.valid_season_or_episode_nr nr
    nr.to_i != 0 || nr.to_i != 99 
  end
end
