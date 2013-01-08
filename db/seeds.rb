# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Configuration.create({:program_id => nil, :active => true, :filter_data => {
  :nzb => {
    :url => 'http://nzbindex.nl/search/',
    :params => {
      'max' => 2,
      'gp[]' => '687',
      'minsize' => '200',
      'complete' => '1',
      'hidespam' => '1'
    },
    :search_param => 'q',
    :extra_search_terms => '',
    :hd_terms => '720'
  },
  :torrent => {
    :url => 'http://isohunt.com/torrents/',
    :search_param => 'ihq'
  } }
})