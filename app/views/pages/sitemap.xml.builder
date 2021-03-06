xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.tag! 'url' do
    xml.tag! 'loc', programs_url
    xml.tag! 'lastmod', Program.order('updated_at').last.updated_at.strftime("%Y-%m-%d")
    xml.tag! 'changefreq', 'hourly'
    xml.tag! 'priority', '0.8'
  end
  @programs.active.each do |program|
    xml.tag! 'url' do
      xml.tag! 'loc', program_url(program)
      xml.tag! 'lastmod', program.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'daily'
      xml.tag! 'priority', '0.9'
    end
  end
  @episodes.active.each do |episode|
    xml.tag! 'url' do
      xml.tag! 'loc', program_episode_url(episode.program, episode)
      xml.tag! 'lastmod', episode.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'weekly'
      xml.tag! 'priority', '1'
    end
  end
  @programs.inactive.each do |program|
    xml.tag! 'url' do
      xml.tag! 'loc', program_url(program)
      xml.tag! 'lastmod', program.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'monthly'
      xml.tag! 'priority', '0.3'
    end
  end
end