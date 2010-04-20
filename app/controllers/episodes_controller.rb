class EpisodesController < ApplicationController
  before_filter :get_episode, :except => :index
  
  def show
  end

  def download
    redirect_to @episode.search_url
  end

  def mark
    @episode.update_attribute(:downloaded, true)
    @header_title = "Season #{@episode.season.nr} ( #{@episode.season.episodes.downloaded.count} / #{@episode.season.episodes.aired.count} / #{@episode.season.episodes.count} )"
  end

  def get_episode
    @episode = Episode.find(params[:id], :include => {:season => :program})
  end
end
