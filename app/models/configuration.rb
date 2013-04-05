class Configuration
  # only class methods
  class << self
    def root_url
      'http://nzbindex.nl/search/'
    end

    def default_params
      {
        minsize: 250,
        complete: 1,
        hidespam: 1,
      }
    end

    def additional_terms
      '-wmv -german -french'
    end

    def search_term_pattern
      "%{program_name} S%{filled_season_nr}E%{filled_episode_nr}"
    end
  end

  def search_terms search_terms
    [search_terms, additional_terms].flatten.join ' '
  end

  def params search_terms
    default_params.merge(q: self.search_terms(search_terms))
  end

  def url *search_terms
    self.root_url + "?" + params(search_terms).to_query
  end

  #   def search_params(search, additional_params = {})
  #     self.search_params.merge!( self.query_param(search) ).merge!( additional_params )
  #   end

  #   def query_param(search)
  #     search << ' ' << additional_terms unless additional_terms.blank?
  #     { filter_data[:nzb][:search_param].to_sym => search }
  #   end

  #   def search_url(query, additional_params = {})
  #     self.root_search_url + '?' + search_params(query+additional_terms, additional_params).to_query
  #   end
end
