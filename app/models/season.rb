class Season < ActiveRecord::Base
  include Pacecar
  
  belongs_to :program
  has_many :episodes, :dependent => :destroy
  
  validates :nr, :uniqueness => { :scope => :program_id }

  attr_accessor :full_name, :season
  
  def <=>(o)
    int_comp = self.to_i <=> o.to_i
    return int_comp #unless int_comp == 0
  end

  def self.string_to_season(season_string)
    season_string.match(/(\d+)/)[1].to_i
  end
  
  def to_i
    nr.to_i || self.full_name.match(/(\d+)/)[1].to_i
  end
  
  def to_s
    self.full_name || nr
  end
  
  def last_episode
    episodes.sort.last
  end
  
  def next_episode(short = false)
    return last_episode.to_i.succ if short
    e    = last_episode.clone
    e.nr = e.nr.succ
    e
  end

end
