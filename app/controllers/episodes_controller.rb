class EpisodesController < ApplicationController
  respond_to :html, :js, :nzb

  before_filter :authenticate_user!, :only => [:update, :download, :search]

  def show
    @search_terms      = SearchTermType.all
    respond_with episode
  end

  def update
    episode.download_all
    @search_terms      = SearchTermType.all
    respond_with episode
  end

  def download
    @download = episode.downloads.first!
    current_user.interactions.create({
      user:             current_user,
      program:          episode.program,
      episode:          episode,
      interaction_type: 'download',
      format:           'nzb',
      end_point:        @download.download.path,
      referer:          request.referer,
      user_agent:       request.user_agent
    })

    redirect_to @download.download.expiring_url 10.seconds
  end

  def search
    end_point = episode.search_url

    current_user.interactions.create({
      user:             current_user,
      program:          @episode.program,
      episode:          @episode,
      interaction_type: "Search #{params[:quality_code]}",
      format:           'nzb',
      end_point:        end_point,
      referer:          request.referer,
      user_agent:       request.user_agent
    })

    redirect_to end_point
  end


  def episode
    @episode ||= Episode.includes(:program, downloads: :search_term_type).find params[:id]
  end
end
