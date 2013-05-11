class ProgramsController < ApplicationController
  respond_to :html, :json, :js

  def index
    @programs = Program.search_program(params[:q]).order('status, name').page params[:page]
    if params[:q] && @programs.first.name.downcase == params[:q].downcase
      redirect_to @programs.first
    else
      respond_with @programs
    end
  end

  def show
    @program          = find_program
    @grouped_episodes = @program.episodes.includes(:downloads).order('season_nr desc, nr desc').group_by(&:season_nr)
    @personal_station = current_user.stations.personal.first if user_signed_in?
  end

  def update
    @program = find_program
    current_user.interactions.create({
      :user => current_user,
      :program => @program,
      :interaction_type => "update program",
      :format => params[:format] || 'html',
      :end_point => url_for(@program),
      :referer          => request.referer,
      :user_agent       => request.user_agent
    })
    @program.delay.tvdb_full_update
  end

  def download_list
    @program = find_program
    @episodes = @program.episodes.last_aired.downloaded
  end

  def guide
    @upcoming_episodes = Episode.next_airing.includes(:program).limit(100)
    @past_episodes     = Episode.last_aired.includes(:program).includes(:downloads).page params[:page]
  end

  private
  def find_program
    Program.find(params[:id])
  end
end
