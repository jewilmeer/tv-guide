# == Schema Information
# Schema version: 20101130174533
#
# Table name: configurations
#
#  id          :integer(4)      not null, primary key
#  program_id  :integer(4)
#  active      :boolean(1)      default(TRUE)
#  filter_data :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Configuration < ActiveRecord::Base
  belongs_to :program
  
  serialize :filter_data
  
  def root_search_url
    # hard override
    filter_data[:nzb][:url]
  end
  
  def search_params(search, additional_params = {})
    params.merge!( self.query_param(search) ).merge!( additional_params )
  end
  
  def query_param(search)
    search << ' ' << additional_terms unless additional_terms.blank?
    { filter_data[:nzb][:search_param].to_sym => search }
  end
  
  def search_url(query, additional_params = {})
    root_search_url + '?' + search_params(query, additional_params).to_query
  end
  
  # cache the result to avoid database calls
  def self.default custom_options = {}
    @c = self.first
    @c.filter_data.merge!( custom_options )
    @c
  end
  
  def params
    filter_data[:nzb][:params]
    # {
    #   :min => '100',
    #   :m => 'search'
    # }
  end
  
  def additional_terms
    filter_data[:nzb][:extra_search_terms]
  end
  
  def hd_terms
    filter_data[:nzb][:hd_terms]
  end
  
  def roman?
    filter_data.each do |k,v|
      return true if v.keys.include?(:roman)
    end
    false
  end
  
  def season_episode_param(season, episode)
    default_pattern = "S%{season}E%{episode}"
    
  end
end
