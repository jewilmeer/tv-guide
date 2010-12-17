class EpisodesController < ApplicationController
  before_filter :get_episode, :except => :index
  before_filter :require_user, :only => [:download, :search]
  
  def show
    respond_to do |format|
      format.html {}
      format.nzb  do
        require_user
        if @episode.downloads.any?
          # redirect for links living on external storage
          download = @episode.downloads.last
          path     = download.download.path

          current_user.interactions.create({
            :user             => current_user, 
            :program          => @episode.program, 
            :episode          => @episode, 
            :interaction_type => 'download',
            :format           => params[:format] || 'nzb',
            :end_point        => path
          })
          redirect_to(AWS::S3::S3Object.url_for(path, download.download.bucket_name, :expires_in => 10.seconds))
        else
          search
        end
      end
    end
  end

  def download
  end

  def download_from_rss
  end
  
  def search
    end_point = @episode.search_url(params[:hd])
    current_user.interactions.create({
      :user => current_user, 
      :program => @episode.program, 
      :episode => @episode, 
      :interaction_type => params[:hd] ? 'search HD' : 'search',
      :format => params[:format] || 'nzb',
      :end_point => end_point
    })
    redirect_to end_point
  end
  
  def mark
    # @episode.update_attribute(:downloaded, true)
    # @header_title = "Season #{@episode.season.nr} ( #{@episode.season.episodes.downloaded.count} / #{@episode.season.episodes.aired.count} / #{@episode.season.episodes.count} )"
  end

  def get_episode
    @episode = Episode.find(params[:id], :include => [:season, :program])
    raise ActiveRecord::RecordNotFound unless @episode
  end
  
  # def single_access_allowed?
  #   params[:action] == :download
  # end
end
