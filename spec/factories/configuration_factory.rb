# == Schema Information
#
# Table name: configurations
#
#  id          :integer          not null, primary key
#  program_id  :integer
#  active      :boolean          default(TRUE)
#  filter_data :text
#  created_at  :datetime
#  updated_at  :datetime
#

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
