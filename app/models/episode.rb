class Episode < ActiveRecord::Base
  include Pacecar
  
  belongs_to :season
  has_one :program, :through => :season
  
  validates :title, :presence => true
  validates :nr, :uniqueness => {:scope => :season_id}
  
  scope :by_nr, lambda {|nr| {:conditions => {:nr => nr} } }
  scope :downloaded, {:conditions => {:downloaded => true} }
  scope :aired, lambda { { :conditions => ['airdate < ?', Date.today] } }
  scope :aired_on, lambda {|date| { :conditions => ['airdate = ?', date] } }
  
  attr_accessor :options, :name, :episode, :filters, :real_filename

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
  
  # def changed?
  #   filename != renamed_filename
  # end
  # 
  # def changed
  #   { filename => renamed_filename } unless filename == renamed_filename
  # end
  # 
  # def change!
  #   FileUtils.mv(path, File.join( File.dirname(path), renamed_filename )) if File.exists?(path)
  #   self.path = File.join( File.dirname(path), renamed_filename )
  #   if self.valid?
  #     logger.info "saving.... #{self.save}"
  #   else
  #     logger.error self.errors.inspect
  #   end
  # end

  def search_url
    APP_CONFIG[:links]['download_url'] + search_query
  end
  
  def search_query
    "#{season_and_episode} 720 #{program}".split(' ').join("+")
  end
  
  def season_and_episode
    "S#{"%02d" % season.to_i}E#{episode}"
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
end
