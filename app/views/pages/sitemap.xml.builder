xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.tag! 'url' do
    xml.tag! 'loc', programs_url
    xml.tag! 'lastmod', Program.by_updated_at.last.updated_at.strftime("%Y-%m-%d")
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
  Episode.includes(:program).airs_at_inside(2.months.ago, 2.months.from_now).each do |episode|
    xml.tag! 'url' do
      xml.tag! 'loc', program_episode_url(episode.program, episode)
      xml.tag! 'lastmod', episode.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'daily'
      xml.tag! 'priority', '0.7'
    end
  end
end