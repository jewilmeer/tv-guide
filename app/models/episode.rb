class Episode < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  belongs_to :program
  has_and_belongs_to_many :users
  has_many :interactions, :dependent => :nullify
  has_many :downloads, :dependent => :destroy
  belongs_to :image

  validates :title, :season_nr, :program_id, :presence => true
  validates :nr, :presence => true, :uniqueness => {:scope => [:season_nr, :program_id]}

  scope :downloaded,              includes(:downloads).where('downloads.id IS NOT NULL')
  scope :season_episode_matches,  lambda{|season, episode| {:conditions => ['episodes.nr = :episode AND episodes.season_nr = :season ', {:episode => episode, :season => season}] } }
  scope :airs_at_in_future,       lambda{ where('episodes.airs_at > ?', Time.zone.now) }
  scope :airs_at_in_past,         lambda{ where('episodes.airs_at < ?', Time.zone.now) }
  scope :airs_at_inside,          ->(first_date, last_date) { where{ (airs_at > first_date) & (airs_at < last_date) } }
  scope :next_airing,             lambda{ airs_at_in_future.order('episodes.airs_at asc') }
  scope :last_aired,              lambda{ airs_at_in_past.order('episodes.airs_at desc') }
  scope :tvdb_id,                 select("id, tvdb_id")
  scope :random,                  -> { order('RANDOM()') }
  scope :distinct_program_id,     lambda{|additional_selects| select("DISTINCT episodes.program_id, #{additional_selects}") }
  scope :last_updated,            order('episodes.updated_at desc')
  scope :without_image,           where('image_id IS NULL')

  attr_accessor :options, :name, :episode, :filters, :thumb

  before_validation :update_program_name

  def <=>(o)
    program_comp = self.program.name <=> o.program.name
    return program_comp unless program_comp == 0

    season_comp = self.season_nr <=> o.season_nr
    return season_comp unless season_comp == 0

    episode_comp = self.episode <=> o.episode
    return episode_comp #unless int_comp == 0
  end

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
    active_configuration.search_url( search_query(extra_terms), {:age => self.age})
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

  def download_types
    program.search_term_types
  end

  def download_all
    logger.info "="*30
    logger.info "Getting downloads for: #{download_types.map(&:name).to_s}"
    logger.info "="*30
    download_types.map{|dt| self.download dt}
  end

  def download search_term_type
    search_url = search_url( search_term_type.code )
    download   = downloads.find_or_initialize_by_download_type( search_term_type.code )

    logger.info "="*30
    logger.info "Getting #{search_term_type.name} from #{search_url}"
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

  def thumb=url
    return false unless url.present?

    logger.debug "==" * 20
    logger.debug "Setting image to #{url}"
    logger.debug "==" * 20

    i = find_existing_image_by_url( url )
    i.image_type = 'episode'
    i.programs << self.program unless i.programs.include? program
    self.image = i
    logger.debug "==" * 20
    logger.debug "i.changed? #{i.changed?} :: #{i.changes.inspect}"
    logger.debug "==" * 20
    i.save! if i.changed?
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
    logger.debug "applying tvdb attributes for episode"

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

  def active_configuration
    program.active_configuration
  end

  def search_term_pattern
    active_configuration.search_term_pattern || "%{program_name} S%{filled_season_nr}E%{filled_episode_nr}"
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

  def self.to_be_downloaded
    tmp_scope = scoped.dup
    downloaded_episodes = Download.where{ episode_id.in tmp_scope.pluck(:id) }.pluck(:episode_id)
    scoped.where{ id.not_in downloaded_episodes }
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

