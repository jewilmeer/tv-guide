xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Digital tv guide - #{@program.name}"
    xml.description "Whole episode download"
    xml.url program_url( @program )
    @program.episodes.order('season_nr desc, nr desc').downloaded.each do |episode|
      xml.item do
        xml.title "#{episode.program.name} - #{episode.full_episode_title}"
        xml.description episode.description
        xml.url episode_download_url(episode.program, episode, current_user.single_access_token, :format => :nzb)
        xml.link episode_download_url(episode.program, episode, current_user.single_access_token, :format => :nzb)
        xml.pubdate episode.airs_at
      end
    end
  end
end