class Configuration < ActiveRecord::Base
  belongs_to :program
  
  serialize :filter_data
  
  def root_search_url
    filter_data[:nzb][:url]
  end
  
  def search_params(search, hd=true)
    params = filter_data[:nzb][:params]
    params.merge!( self.query_param(search, hd) )
    params
  end
  
  def query_param(search, hd=true)
    search << ' ' << filter_data[:nzb][:extra_search_terms] unless filter_data[:nzb][:extra_search_terms].blank?
    search << ' ' << filter_data[:nzb][:hd_terms] if hd
    { filter_data[:nzb][:search_param].to_sym => search }
  end
  
  def search_url(query, hd=true)
    root_search_url + '?' + search_params(query, hd).to_query
  end
  
  # cache the result to avoid database calls
  def self.default
    @default ||= Configuration.first
  end
end