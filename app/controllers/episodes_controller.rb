class EpisodesController < ApplicationController
  layout 'fluid'
  respond_to :html, :js, :nzb

  before_filter :authenticate_user_from_token!, only: :download
  before_filter :authenticate_user!, :only => [:update, :download, :search]

  def show
    @program = program
    @episode = @program.episodes.find(params[:id])

    if !user_signed_in? && stale?(etag: @episode, last_modified: @program.updated_at, public: true)
      @grouped_episodes = @program.episodes.includes(:downloads).
        order('season_nr desc, nr desc').group_by(&:season_nr)
    end
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

  def program
    Program.friendly.find params[:program_id]
  end

  def episode
    Episode.includes(:program, :downloads).find params[:id]
  end
end
