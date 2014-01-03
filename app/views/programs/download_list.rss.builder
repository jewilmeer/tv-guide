xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Digital TV guide"
    xml.description "Shit you can download"
    xml.url program_url(@program)
    @episodes.each do |episode|
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