class Program < ActiveRecord::Base
  include Pacecar
  require 'open-uri'
  require 'tvdb'
  require 'aws/s3'
  
  has_many :seasons, :dependent => :destroy
  has_many :episodes, :through => :seasons, :dependent => :destroy
  has_many :program_updates, :dependent => :destroy
  has_and_belongs_to_many :users, :uniq => true
  has_one :configuration, :dependent => :destroy
  has_and_belongs_to_many :images
  
  validates :name, :presence => true, :uniqueness => true
  # before_validation :guess_correct_name, :on => :create
  before_create :find_additional_info, :fill_search_term, :get_banner
  after_create :retrieve_episodes
    
  scope :by_name, :order => 'name ASC'
  
  attr_accessor :active_configuration, :banners, :banner
  cattr_accessor :tvdb_client
  
  has_attached_file :banner, 
                    :processors     => [], 
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :s3_permissions => 'public-read',
                    :s3_protocol    => 'http',
                    :s3_headers     => { :content_type => 'application/octet-stream', :content_disposition => 'attachment' },
                    :bucket         => Rails.env.production? ? 'tv-guide' : 'tv-guide-dev',
                    :path           => ':attachment/:id/:style/:filename'
  
  def self.tvdb_client
    @tvdb_client ||= TVdb::Client.new(APP_CONFIG[:thetvdb]['api_key'])
  end
  
  def self.tvdb_search(query, options = {})
    # setup tvdb wrapper client
    self.tvdb_client.search(query.downcase.humanize, options)
  end

  def self.search(query)
    if query
      if %w(development test).include?(Rails.env)
        where(query , :on => [:name, :search_term, :description]) 
      else
        where(['name ILIKE :query OR search_term ILIKE :query OR description ILIKE', {:query => "%#{query}%"}])
      end
    else
      scoped
    end
  end

  def active_configuration
    @active_configuration ||= (self.configuration ? self.configuration : Configuration.default)
  end
  
  def banners
    @banners ||= self.class.tvdb_client.get_banners(self.tvdb_id)
  end
  
  # def banner
  #   @banner ||= (
  #     read_attribute(:banner) || get_banner
  #   )
  # end
  
  def tvdb_banner_url
    "http://www.thetvdb.com/banners/" + banners.detect{|banner| banner[:subtype] == 'graphical' }[:path]
  rescue StandardError
    false
  end
  
  def tvdb_banner_urls
    banners.map do |banner|
      "http://www.thetvdb.com/banners/" + banner[:path]
    end
  end
  
  def tvdb_banner_filename
    return false unless tvdb_banner_url
    tvdb_banner_url.split('/').last
  end
  
  def filename
    "#{self.name.parameterize}-banner.jpg"
  end
  
  def get_banner
    return false unless tvdb_banner_filename
    tmp_filepath = "tmp/#{self.name.parameterize}-banner-#{tvdb_banner_filename}"
    open(tvdb_banner_url) {|tmp_file| self.banner= tmp_file}
  end
    
  def banner_url
    AWS::S3::S3Object.url_for(self.banner.path, self.banner.bucket_name)
  end
  
  def episode_list
    @episode_list ||= self.class.tvdb_client.get_episodes(self.tvdb_id)
  end

  # def episode_list
  #   return @episode_list if @episode_list 
  #   @episode_list = []
  # 
  #   raise 'Episodelist url is missing' unless episodelist_url
  #   logger.info "getting episode titles from #{episodelist_url.inspect}"
  # 
  #   page = Browser.agent.get(episodelist_url).body
  #   # get the pre element, each line should contain show info
  #   plain_text = Nokogiri::HTML(page).search('pre').first
  #   
  #   plain_text.to_s.split("\n").each_with_index do |line, index|
  #     if line.length > 100
  #       logger.debug line
  #       match = line.match('(\d+)- ?(\d{1,2}).*?(\d{1,2}[ \/]+\w{1,3}[ \/]+\d{1,2}).*<.*>(.*)<').to_a
  #       if match.any?
  #         episode = "%02d" % match[2].to_i
  #         episode_list << {
  #           :season => match[1].to_i,
  #           :episode => match[2].to_i,
  #           :airdate => Date.parse(match[3].gsub('/', ' ')),
  #           :title => match[4],
  #           :season_and_episode => "S#{"%02d" % match[1].to_i.to_i}E#{"%02d" % match[2].to_i}"
  #         }
  #         
  #       end
  #     end
  #   end
  #   logger.debug episode_list
  #   episode_list
  # end
  # 
  # def episodelist_url
  #   google_result.uri
  # end
  # 
  # def google_url
  #   URI.escape "#{APP_CONFIG[:links]['search_url']} \"#{self}\" site:epguides.com"
  # end
  # 
  # def google_result
  #   Browser.agent.get(self.google_url).links.find{|l| l.text =~ /Titles & Air Dates/}
  # end
  # 
  # def episodelist_search_result
  #   google_result = get_page(google_url)
  # end
  # 
  # def get_first_result(search_result)
  #   links = Nokogiri::HTML( search_result ).css('.l')
  #   links.any? ? links.attr('href').to_s : false
  # end
  # 
  # def get_page(url)
  #   Browser.agent.get(url)
  # end
  # 
  # def get_all_episodes
  #   current_season = nil
  #   episode_list.each do |ep_info|
  #     unless current_season && current_season.nr == ep_info[:season]
  #       current_season = self.seasons.find_or_create_by_nr( ep_info[:season] )
  #       logger.debug '='*40
  #       logger.debug "current_season: #{current_season.to_s}"
  #       logger.debug '='*40
  #     end
  #     
  #     episode = current_season.episodes.by_nr(ep_info[:episode]).first
  #     episode = current_season.episodes.create({
  #       :nr => ep_info[:episode],
  #       :title => ep_info[:title],
  #       :airdate => ep_info[:airdate]
  #     }) unless episode && episode.nr == ep_info[:episode]
  #   end
  #   logger.debug "nr of episodes found: #{episode_list.count}"
  # end
  # 
  # def episodelist_needs_update?
  #   self.episode_list.length != self.episodes.count
  # end
  # 
  # # TODO: watch for new seasons
  # def new_episodes
  #   last_season  = self.seasons.last.nr
  #   all_episodes = self.episodes.map(&:season_and_episode)
  #   episode_list.reject{|e| all_episodes.include?(e[:season_and_episode]) }
  # end
  # 
  # def add_new_episodes
  #   last_season     = self.seasons.last
  #   new_episodes.each do |e|
  #     raise "seasons does not match #{self} #{last_season.nr} <> #{e[:season]}" unless last_season.nr == e[:season]
  #     ep = last_season.episodes.build(:nr => e[:episode], :title => e[:title], :airdate => e[:airdate])
  #     if ep.save
  #       logger.debug "Episode added: #{ep.inspect}"
  #     else
  #       logger.debug "Episode save failed: #{ep.inspect}"
  #     end
  #   end
  # end
  # 

  def fill_search_term
    self.search_term     = self.name
    self.last_checked_at = Time.now
  end
  
  def retrieve_episodes(save = true)
    changes = changed? ? [{:program => self.changes}] : []
    self.episode_list.each do |tvdb_episode|
      tmp_changes = nil
      season      = self.seasons.find_or_create_by_nr(tvdb_episode['SeasonNumber'])
      episode     = season.episodes.find_or_initialize_by_nr(tvdb_episode['EpisodeNumber']) do |e|
        e.program_id = self.id
      end
      episode.tvdb_info = tvdb_episode
      
      tmp_changes = {(episode.new_record? ? episode.season_and_episode : episode.id) => episode.changes} if episode.changed?
      if save
         changes << tmp_changes if episode.save && tmp_changes
      end
    end
    if save
      self.program_updates.create(:revision_data => changes) if changes.any?
    else
      self.program_updates.build(:revision_data => changes)
    end
    changes
  end

  def find_additional_info
    self.attributes       = tvdb_info.reject{|k,v| !self.attributes.keys.include?(k) }
    self.name             = tvdb_info['seriesname']
    self.tvdb_id          = tvdb_info['id']
    self.tvdb_last_update = Time.at(tvdb_info['lastupdated'].to_i)
    self.overview         = tvdb_info['overview'].force_encoding("utf-8") if tvdb_info['overview']
    self.genres           = tvdb_info['genre']
    self.tvdb_rating      = tvdb_info['rating']
    self
  end
  
  def needs_update?
    return true if !self.last_checked_at || (self.last_checked_at + 1.hour).past?
  end
  
  def tvdb_info
    tvdb_id     ||= read_attribute(:tvdb_id) || get_tvdb_id
    @tvdb_info  ||= self.class.tvdb_client.get_program_info(tvdb_id).inject({}){|sum,item| sum[item.first.downcase]= item.last; sum }
  end
  
  def get_tvdb_id
    self.class.tvdb_search(self.name, :match_mode => :exact).first['seriesid']
  end
  
  def tvdb_update
    self.find_additional_info
    changed?
    needs_update? && retrieve_episodes
    self.last_checked_at = Time.now
    self.save!
  end
  
  def to_s
    self.name
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
    
  def find_episode_information(episode_key)
    season, episode = Episode.episode_season_split(episode_key)
    episode         = self.episodes.season_episode_matches( season, episode ).first
    # episode.title if episode
  end
  
  def actors
    @actors ||= read_attribute(:actors) || []
    @actors.split('|').compact.reject(&:blank?)
  end
  
  def genres
    @genres ||= read_attribute(:genres) || []
    @genres.split('|').compact.reject(&:blank?)
  end
end