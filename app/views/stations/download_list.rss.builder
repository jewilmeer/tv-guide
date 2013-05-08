xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Digital TV guide - Latest aired"
    xml.description "Your presonal downloads"
    xml.url station_url(@station)
    @episodes.each do |episode|
      xml.item do
        xml.title "#{episode.program.name} - #{episode.full_episode_title}"
        xml.description episode.description
        xml.url download_episode_url(episode, current_user.authentication_token, :format => :nzb)
        xml.link download_episode_url(episode, current_user.authentication_token, :format => :nzb)
        xml.pubdate episode.airs_at
      end
    end
  end
end