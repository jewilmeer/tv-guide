class EpisodesController < ApplicationController
  respond_to :html, :js, :nzb

  before_filter :authenticate_user!, :only => [:update, :download, :search]

  def show
    @search_terms      = SearchTermType.all
    respond_with episode
  end

  def update
    @search_terms      = SearchTermType.all
    episode.ensure_up_to_date
    respond_with @episode
  end

  def download
    if episode.downloads.any?
      # redirect for links living on external storage
      download_type = SearchTermType.find_by_code(params[:download_type])
      download_type ||= current_user.program_preferences.with_program(episode.program).includes(:search_term_type).first.search_term_type

      download = episode.downloads.with_download_type( download_type.code ).first
      if download
        path     = download.download.path

        current_user.interactions.create({
          :user             => current_user,
          :program          => episode.program,
          :episode          => episode,
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

  def download_from_rss; end

  def search
    end_point = episode.search_url( params[:search_type] )

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


  def episode
    @episode ||= Episode.includes(:program, downloads: :search_term_type).find params[:id]
  end
end
