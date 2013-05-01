class Episode < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  belongs_to :program
  has_and_belongs_to_many :users
  has_many :interactions, :dependent => :nullify
  has_many :downloads, :dependent => :destroy
  has_many :stations, through: :program
  belongs_to :image

  validates :title, :season_nr, :program_id, :presence => true
  validates :nr, :presence => true, :uniqueness => {:scope => [:season_nr, :program_id]}

  # used for guide view
  scope :next_airing,             ->{ airs_at_in_future.order('episodes.airs_at asc').includes(:program) }
  scope :last_aired,              ->{ airs_at_in_past.order('episodes.airs_at desc').includes(:program, :downloads) }

  scope :downloaded,              ->(){ includes(:downloads).where('downloads.id IS NOT NULL') }
  scope :watched_by_a_user,       ->(){ includes(:stations).where(stations: {taggable_type: 'User'}) }
  scope :downloadable,            ->(){ without_download.watched_by_a_user }
  scope :without_download,        includes(:downloads).where(downloads: {id: nil})
  scope :airs_at_in_future,       lambda{ where('episodes.airs_at > ?', Time.zone.now) }
  scope :airs_at_in_past,         lambda{ where('episodes.airs_at < ?', Time.zone.now) }
  scope :airs_at_inside,          ->(first_date, last_date) { where{ (airs_at > first_date) & (airs_at < last_date) } }

  scope :tvdb_id,                 select("id, tvdb_id")
  scope :random,                  -> { order('RANDOM()') }
  scope :distinct_program_id,     lambda{|additional_selects| select("DISTINCT episodes.program_id, #{additional_selects}") }
  scope :last_updated,            order('episodes.updated_at desc')
  scope :without_image,           where('image_id IS NULL')

  attr_accessor :options, :name, :episode, :filters, :thumb

  before_validation :update_program_name

  # attribute overwrites
  def airdate=(date)
    super(date)
    set_airs_at_from_airdate date
  end

  def set_airs_at_from_airdate(date)
    return unless date.present?
    return unless program.try(:airs_time)
    Time.zone = self.program.time_zone_offset
    self.airs_at = Time.zone.parse( %(#{date} #{self.program.airs_time}) )
  rescue ArgumentError #invalid date
    date
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

  def search_query(extra_terms)
    ([] << interpolated_search_term << extra_terms) * ' '
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

  def qualities
    ['hd']
  end

  def download_all
    logger.info "="*30
    logger.info "Getting downloads for '#{self.program_name}' in #{qualities.join(', ')}"
    logger.info "="*30
    qualities.map{|quality| self.download quality }
  end

  def download(quality)
    download   = downloads.find_or_initialize_by_download_type( quality )

    logger.info "="*30
    logger.info "Getting #{quality} from #{search_url}"
    logger.info "="*30

    next_page   = Browser.agent.get( search_url ).forms.last.submit
    if (download_links = next_page.links_with(:text => 'Download')).any?
      download.origin = strip_tags(Nokogiri::HTML(next_page.body).css('td label').last.to_s)
      file            = download_links.last.click
      download.file   = file
      download.site   = 'nzbindex.nl'
      download.save
    else
      logger.info "No downloads found at #{search_url}"
      false
    end
  end

  def download_with_reschedule
    return if self.download('hd')

    # reschedule if 'fresh'
    downloadable? && self.delay_for(1.hour).download_with_reschedule
  end

  def max_download_time
    airs_at + 7.days
  end

  # < means before max_download_time
  def downloadable?
    Time.now < max_download_time
  end

  def searcher
    @searcher ||= NzbSearch.new.tap do |searcher|
      searcher.search_terms = "#{self.interpolated_search_term} #{searcher.default_terms}"
      searcher.age = self.age
    end
  end

  def search_url
    searcher.link
  end

  def find_existing_image_by_url url
    Image.find_or_initialize_by_url( url )
  end

  def thumb
    self.image || self.program.images.saved.fanart.random.first || (image = self.program.images.fanart.random.first; image and image.save_image and image.save and image)
  end

  def working?
    last_blame = self.interactions.interaction_type_is('blame').last
    return true unless last_blame
    false
  end

  def self.recently_aired(since=5.minutes.ago)
    airs_at_inside(5.minutes.ago, Time.now)
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

  def tvdb_episode
    tvdb_client.get_episode_by_id self.tvdb_id
  end

  def tvdb_update_hash
    tvdb_client.get_episode_by_id self.tvdb_id
  end

  def tvdb_update
    self.apply_tvdb_attributes tvdb_episode
    save!
  end

  def self.get_episodes_by_tvdb_id tvdb_id
    tvdb_client.get_all_episodes_by_id( tvdb_id ).reject{|e| e.season_number.to_i == 0}
  end

  def update_program_name
    program_name = program.name if program
  end

  def self.valid_season_or_episode_nr nr
    nr.to_i != 0 && nr.to_i != 99
  end

  def search_term_pattern
    "%{program_name} S%{filled_season_nr}E%{filled_episode_nr}"
  end

  def interpolated_search_term
    search_term_pattern % interpolatable_attributes
  end

  def interpolatable_attributes
    {
      program_name: program.search_name,
      title: title,
      season_nr: season_nr,
      episode_nr: nr,
      filled_season_nr: "%02d" % season_nr,
      filled_episode_nr: "%02d" % nr
    }
  end
end

# == Schema Information
#
# Table name: episodes
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :text
#  path             :string(255)
#  nr               :integer
#  airdate          :date
#  downloaded       :boolean          default(FALSE)
#  watched          :boolean          default(FALSE)
#  season_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  nzb_file_name    :string(255)
#  nzb_content_type :string(255)
#  nzb_file_size    :integer
#  nzb_updated_at   :datetime
#  program_id       :integer
#  airs_at          :datetime
#  downloads        :integer          default(0)
#  season_nr        :integer
#  tvdb_id          :integer
#  program_name     :string(255)
#  tvdb_program_id  :integer
#  image_id         :integer
#

