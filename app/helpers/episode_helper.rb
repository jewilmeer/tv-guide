module EpisodeHelper
  def current_episode_data(episode)
    return unless episode
    {
      'episode-id' => episode.id,
      'episode-nr' => episode.nr,
      'episode-season-nr' => episode.season_nr
    }
  end
end