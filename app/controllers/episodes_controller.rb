class EpisodesController < ApplicationController
  before_filter :get_episode, :except => :index
  
  def show
  end

  def download
    redirect_to @episode.search_url
  end

  def mark
    @episode.update_attribute(:downloaded, true)
  end

  def get_episode
    @episode = Episode.find(params[:id], :include => {:season => :program})
  end
end
