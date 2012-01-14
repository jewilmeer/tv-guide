FactoryGirl.define do
  factory :configuration do
    active true
    filter_data({
      :nzb=> {
        :url=>"http://nzbindex.nl/search/", 
        :params=> {
          "max"=>2, 
          "gp[]"=>"687", 
          "minsize"=>"250", 
          "complete"=>"1", 
          "hidespam"=>"1" 
        }, 
        :search_param=>"q", 
        :extra_search_terms=>"", 
        :hd_terms=>"720", 
        :roman=>true 
      }, 
      :torrent => {
        :url=>"http://isohunt.com/torrents/", 
        :search_param=>"ihq"
      }
    })
  end
end