class NzbSearch
  attr_accessor :age, :search_terms
  def link
    [self.root_url, params.to_query].join '?'
  end

  def params
    {
      minsize: 250, #makes it more likely to download an HD version
      complete: 1,
      hidespam: 1,
      q: self.search_terms,
      age: self.age,
    }
  end

  def search_terms
    @search_terms || ''
  end

  def age
    @age || 10
  end

  def default_terms
    '-wmv -german -french 720 | 1080'
  end

  protected
  def root_url
    'http://nzbindex.nl/search/'
  end
end