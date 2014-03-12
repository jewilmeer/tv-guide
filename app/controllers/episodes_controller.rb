class EpisodesController < ApplicationController
  layout 'fluid'
  respond_to :html, :js, :nzb

  before_filter :authenticate_user_from_token!, only: :download
  before_filter :authenticate_user!, :only => [:update, :download, :search]

  def show
    @program = episode.program
    @grouped_episodes = @program.episodes.includes(:downloads).
      order('season_nr, nr desc').group_by(&:season_nr)
    @episode = episode

    fresh_when(etag: [!!current_user, @program, @episode], public: true)
  end

  def update
    episode.download
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
      interaction_type: "Search",
      format:           'nzb',
      end_point:        end_point,
      referer:          request.referer,
      user_agent:       request.user_agent
    })

    redirect_to end_point
  end


  def episode
    @episode ||= Episode.includes(:program, :downloads).find params[:id]
  end
end
