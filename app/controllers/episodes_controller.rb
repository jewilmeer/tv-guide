class EpisodesController < ApplicationController
  before_filter :get_episode, :except => :index
  before_filter :authenticate_user!, :only => [:download, :search]

  def show
    respond_to do |format|
      format.html {}
      format.nzb  do
        authenticate_user!
        if @episode.downloads.any?

          # redirect for links living on external storage
          download_type = SearchTermType.find_by_code(params[:download_type])
          download_type ||= current_user.program_preferences.with_program(@episode.program).includes(:search_term_type).first.search_term_type

          download = @episode.downloads.with_download_type( download_type.code ).first
          if download
            path     = download.download.path

            current_user.interactions.create({
              :user             => current_user,
              :program          => @episode.program,
              :episode          => @episode,
              :interaction_type => 'download',
              :format           => params[:format] || 'nzb',
              :end_point        => path,
              :referer          => request.referer,
              :user_agent       => request.user_agent
            })
            redirect_to( download.download.expiring_url 10.seconds )
          else
            search
          end
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
    end_point = @episode.search_url( params[:search_type] )
    current_user.interactions.create({
      :user => current_user,
      :program => @episode.program,
      :episode => @episode,
      :interaction_type => "Search #{params[:search_type]}",
      :format => params[:format] || 'nzb',
      :end_point => end_point,
      :referer          => request.referer,
      :user_agent       => request.user_agent
    })
    redirect_to end_point
  end


  def get_episode
    @episode = Episode.find(params[:id], :include => :program)
    raise ActiveRecord::RecordNotFound unless @episode
  end
end
