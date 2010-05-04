class Program < ActiveRecord::Base
  include Pacecar
  require 'open-uri'
  has_many :seasons, :dependent => :destroy
  has_many :episodes, :through => :seasons, :dependent => :destroy do
    def last_aired_before(date)
      first(:conditions => ['episodes.airdate < :date', :date => date], :order => 'episodes.airdate DESC')
    end
    def first_aired_after(date)
      first(:conditions => ['episodes.airdate > :date', :date => date], :order => 'episodes.airdate ASC')
    end
  end
  has_and_belongs_to_many :users
  
  validates :name, :presence => true, :uniqueness => true
  after_create :get_all_episodes
    
  scope :by_name, :order => 'name ASC'
  
  def episode_list
    return @episode_list if @episode_list 
    @episode_list = []

    logger.info "getting episode titles from #{episodelist_url}"
    raise unless episodelist_url
    page = get_page(episodelist_url)
    # get the pre element, each line should contain show info
    plain_text = Nokogiri::HTML(page).search('pre').first
    
    plain_text.to_s.split("\n").each_with_index do |line, index|
      if line.length > 100
        logger.debug line
        # match = line.match('(\d+)- ?(\d{1,2}).*>(.*)<').to_a #old one
        match = line.match('(\d+)- ?(\d{1,2}).*?(\d{1,2}[ \/]+\w{1,3}[ \/]+\d{1,2}).*<.*>(.*)<').to_a
        if match.any?
          episode = "%02d" % match[2].to_i
          episode_list << {
            :season => match[1].to_i,
            :episode => match[2].to_i,
            :airdate => Date.parse(match[3].gsub('/', ' ')),
            :title => match[4]
          }
        end
      end
    end
    logger.debug episode_list
    episode_list
  end
  
  def episodelist_url
    return @episodelist_url if @episodelist_url
    # logger.debug google_result
    
    # @episodelist_url = Nokogiri::HTML( episodelist_search_result ).css('a.l').first['href']
    get_first_result( episodelist_search_result )
  end
  
  def google_url
    URI.escape "#{APP_CONFIG[:links]['search_url']} \"#{self}\" site:epguides.com"
  end

  def episodelist_search_result
    google_result = get_page(google_url)
  end
  
  def get_first_result(search_result)
    links = Nokogiri::HTML( search_result ).css('.l')
    links.any? ? links.attr('href').to_s : false
  end
  
  def get_page(url)
    page  = ''
    open(url).each{|line| page << line }
    page
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
    last_eplist = self.episode_list.last
    last_episode= self.episodes.last

    last_episode.season.nr == last_eplist[:season] && 
    last_episode.nr        == last_eplist[:episode] && 
    last_episode.title     == last_eplist[:title]
  end
  
  def update_episode_list
    self.episodes.last
  end
  
  def next_episode_to_download
    last_episode = episodes.last(:downloaded => true)
    next_episode = last_episode.season.episodes.first(:nr => last_episode.nr.succ)
    next_episode.is_a?(Episode) ? next_episode.search_url : nil
  end
  
  def self.downloads
    downloads = []
    all.map{|p| downloads << p.next_episode_to_download }
    downloads.compact
  end
  
  def to_s
    self.name
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
