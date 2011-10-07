xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.tag! 'url' do
    xml.tag! 'loc', root_url
    xml.tag! 'lastmod', Episode.by_updated_at.last.updated_at.strftime("%Y-%m-%d")
    xml.tag! 'changefreq', 'hourly'
    xml.tag! 'priority', '0.9'
  end
  xml.tag! 'url' do
    xml.tag! 'loc', programs_url
    xml.tag! 'lastmod', Episode.by_updated_at.last.updated_at.strftime("%Y-%m-%d")
    xml.tag! 'changefreq', 'hourly'
    xml.tag! 'priority', '0.8'
  end
  Program.all.each do |program|
    xml.tag! 'url' do
      xml.tag! 'loc', program_url(program)
      xml.tag! 'lastmod', program.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'hourly'
      xml.tag! 'priority', '0.9'
    end  
  end
    Episode.airs_at_inside(2.months.ago, 2.months.from_now).each do |episode|
    xml.tag! 'url' do
      xml.tag! 'loc', program_episode_url(episode.program, episode)
      xml.tag! 'lastmod', episode.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'daily'
      xml.tag! 'priority', '0.7'
    end  
  end
  xml.tag! 'url' do
    xml.tag! 'loc', pages_program_updates_url
    xml.tag! 'lastmod', Episode.by_created_at.last.created_at.strftime("%Y-%m-%d")
    xml.tag! 'changefreq', 'hourly'
    xml.tag! 'priority', '0.9'
  end  
  
  # @games.each do |game|
  #   xml.tag! 'url' do
  #     xml.tag! 'loc', game_url(game)
  #     xml.tag! 'lastmod', game.updated_at.strftime("%Y-%m-%d")
  #     xml.tag! 'changefreq', 'monthly'
  #     xml.tag! 'priority', '0.8'
  #   end
  # end
  # @tags.each do |tag|
  #   xml.tag! 'url' do
  #     xml.tag! 'loc', smart_tag_url(tag)
  #     xml.tag! 'lastmod', tag.updated_at.strftime("%Y-%m-%d")
  #     xml.tag! 'changefreq', 'weekly'
  #     xml.tag! 'priority', '0.7'
  #   end
  # end
  
end