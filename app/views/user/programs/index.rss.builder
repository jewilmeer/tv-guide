xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Digital tv guide - Latest aired"
    xml.description "Your presonal guide"
    xml.url user_programs_url(@user)
    @past_episodes.each do |episode|
      xml.item do
        xml.title "#{episode.program.name} - #{episode.full_episode_title}"
        xml.description episode.description
        xml.pubdate episode.airs_at
      end
    end
  end
end