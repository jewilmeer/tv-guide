xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Digital TV guide - #{@program.name}"
    xml.description "Whole episode download"
    xml.url program_url( @program )
    @program.episodes.order('season_nr desc, nr desc').downloaded.each do |episode|
      xml.item do
        xml.title "#{episode.program.name} - #{episode.full_episode_title}"
        xml.description episode.description
        xml.url download_program_episode_url(@program, episode, current_user.authentication_token, :format => :nzb)
        xml.link download_program_episode_url(@program, episode, current_user.authentication_token, :format => :nzb)
        xml.pubdate episode.airs_at
      end
    end
  end
end