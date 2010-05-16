class Program < ActiveRecord::Base
  include Pacecar
  require 'open-uri'

  has_many :seasons, :dependent => :destroy
  has_many :episodes, :through => :seasons, :dependent => :destroy
  has_and_belongs_to_many :users
  has_one :configuration
  
  validates :name, :presence => true, :uniqueness => true
  before_validation :guess_correct_name, :on => :create
  before_create :fill_search_term
  after_create :get_all_episodes
    
  scope :by_name, :order => 'name ASC'
  
  attr_accessor :active_configuration

  def guess_correct_name
    self.name = google_result.text.match(/(.*?) \(.*\)/)[1]
  rescue StandardError => e
    logger.error e
    name
  end
  
  def active_configuration
    @active_configuration ||= (self.configuration ? self.configuration : Configuration.default)
  end
  
  def episode_list
    return @episode_list if @episode_list 
    @episode_list = []

    raise 'Episodelist url is missing' unless episodelist_url
    logger.info "getting episode titles from #{episodelist_url.inspect}"

    page = Browser.agent.get(episodelist_url).body
    # get the pre element, each line should contain show info
    plain_text = Nokogiri::HTML(page).search('pre').first
    
    plain_text.to_s.split("\n").each_with_index do |line, index|
      if line.length > 100
        logger.debug line
        match = line.match('(\d+)- ?(\d{1,2}).*?(\d{1,2}[ \/]+\w{1,3}[ \/]+\d{1,2}).*<.*>(.*)<').to_a
        if match.any?
          episode = "%02d" % match[2].to_i
          episode_list << {
            :season => match[1].to_i,
            :episode => match[2].to_i,
            :airdate => Date.parse(match[3].gsub('/', ' ')),
            :title => match[4],
            :season_and_episode => "S#{"%02d" % match[1].to_i.to_i}E#{"%02d" % match[2].to_i}"
          }
          
        end
      end
    end
    logger.debug episode_list
    episode_list
  end
  
  def episodelist_url
    google_result.uri
  end
  
  def google_url
    URI.escape "#{APP_CONFIG[:links]['search_url']} \"#{self}\" site:epguides.com"
  end

  def google_result
    Browser.agent.get(self.google_url).links.find{|l| l.text =~ /Titles & Air Dates/}
  end
  
  def episodelist_search_result
    google_result = get_page(google_url)
  end
  
  def get_first_result(search_result)
    links = Nokogiri::HTML( search_result ).css('.l')
    links.any? ? links.attr('href').to_s : false
  end
  
  def get_page(url)
    Browser.agent.get(url)
  end
  
  def get_all_episodes
    current_season = nil
    episode_list.each do |ep_info|
      unless current_season && current_season.nr == ep_info[:season]
        current_season = self.seasons.find_or_create_by_nr( ep_info[:season] )
        logger.debug '='*40
        logger.debug "current_season: #{current_season.to_s}"
        logger.debug '='*40
      end
      
      episode = current_season.episodes.by_nr(ep_info[:episode]).first
      episode = current_season.episodes.create({
        :nr => ep_info[:episode],
        :title => ep_info[:title],
        :airdate => ep_info[:airdate]
      }) unless episode && episode.nr == ep_info[:episode]
    end
    logger.debug "nr of episodes found: #{episode_list.count}"
  end
  
  def episodelist_needs_update?
    self.episode_list.length != self.episodes.count
  end

  # TODO: watch for new seasons
  def new_episodes
    last_season  = self.seasons.last.nr
    all_episodes = self.episodes.map(&:season_and_episode)
    episode_list.reject{|e| all_episodes.include?(e[:season_and_episode]) }
  end
  
  def add_new_episodes
    last_season     = self.seasons.last
    new_episodes.each do |e|
      raise 'seasons does not match' unless last_season.nr == e[:season]
      last_season.episodes.create!(:nr => e[:episode], :title => e[:title], :airdate => e[:airdate])
    end
  end
  
  def fill_search_term
    self.search_term = self.name
  end
  
  # def to_s
  #   self.name
  # end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end