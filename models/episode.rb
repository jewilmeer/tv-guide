class Episode < ActiveRecord::Base
  include Pacecar
  
  belongs_to :season
  has_one :program, :through => :season
  
  validates :title, :presence => true
  validates :nr, :presence => true, :uniqueness => {:scope => :season_id}
  
  scope :by_nr, lambda {|nr| {:conditions => {:nr => nr} } }
  scope :downloaded, {:conditions => {:downloaded => true} }
  scope :watched_by_user, lambda{|programs| {:conditions => ['season_id IN (?)', programs.map(&:season_ids).flatten] }}
  
  attr_accessor :options, :name, :episode, :filters, :real_filename
  
  has_attached_file :nzb, :processors => [], url: '/system/:attachment/:id/:style/:filename.nzb'
  
  def <=>(o)
    program_comp = self.program.name <=> o.program.name
    return program_comp unless program_comp == 0

    season_comp = self.season.to_i <=> o.season.to_i
    return season_comp unless season_comp == 0

    episode_comp = self.episode <=> o.episode
    return episode_comp #unless int_comp == 0
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
    (airdate - Date.today).to_i.abs
  end

  def search_url
    program.active_configuration.search_url(search_query, {:age => self.age})
  end
  
  def search_query
    [program.name, season_and_episode, program.active_configuration.hd_terms] * ' '
  end
  
  def season_and_episode
    # if self.program.filters.roman
    #   "S#{"%02d" % season.to_i}Part#{nr.to_s_roman}"
    # else
      "S#{"%02d" % season.to_i}E#{episode}"
    # end
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
  
  def aired?
    self.airdate < Date.today
  end
  
  def view_classes
    classes = []
    classes << 'downloaded' if downloaded
    classes << 'inactive' unless aired?
    classes << 'active' if aired?
    classes * ' '
  end
  
  def get_nzb
    logger.debug "Getting nzbfile from #{search_url}"
    tmp_filepath = "tmp/#{filename}.nzb"
    agent        = Browser.agent
    first_page   = agent.get(search_url).forms.last.submit

    if (download_links = first_page.links_with(:text => 'Download')).any?
      file = download_links.last.click.save(tmp_filepath)
    end
    
    return 'failed to download' unless file
    
    File.open(tmp_filepath) {|nzb_file| self.nzb = nzb_file }
    self.save
    File.delete(tmp_filepath)
  end
end
