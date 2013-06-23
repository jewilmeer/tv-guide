class ProgramsController < ApplicationController
  respond_to :html, :json, :js

  def index
    @programs = Program.order('status, name').search_program(params[:q]).page params[:page]
    if matched_program = exact_match_found?(@programs, params[:q])
      redirect_to matched_program
    else
      respond_with @programs
    end
  end

  def show
    @program          = Program.friendly.find params[:id]
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
    @asked_itme        = rounded_time
    @upcoming_episodes = Episode.next_airing_at(rounded_time).limit(100)
    @past_episodes     = Episode.last_aired_at(rounded_time).page params[:page]
  end

  private
  def find_program
    Program.find(params[:id])
  end

  def exact_match_found?(programs, query)
    return false unless query.present?
    programs.find { |program| program.name.downcase == query.downcase }
  end

  def rounded_time
    Time.at(Time.now.to_i - (Time.now.to_i % 1.hour))
  end
end
