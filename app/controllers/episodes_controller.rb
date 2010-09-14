class EpisodesController < ApplicationController
  before_filter :get_episode, :except => :index
  before_filter :require_user, :only => [:download, :search]
  
  def show
  end

  def download
    if @episode.nzb?
      # track donwnloads
      current_user.episodes << @episode
      
      # redirect for links living on external storage
      path = @episode.nzb.path
      redirect_to(AWS::S3::S3Object.url_for(@episode.nzb.path, @episode.nzb.bucket_name, :expires_in => 10.seconds))
    else
      search
    end
  end
  
  def search
    redirect_to @episode.search_url(params[:hd])
  end
  
  def mark
    # @episode.update_attribute(:downloaded, true)
    # @header_title = "Season #{@episode.season.nr} ( #{@episode.season.episodes.downloaded.count} / #{@episode.season.episodes.aired.count} / #{@episode.season.episodes.count} )"
  end

  def get_episode
    @episode = Episode.find(params[:id], :include => [:season, :program])
    raise ActiveRecord::RecordNotFound unless @episode
  end
end
