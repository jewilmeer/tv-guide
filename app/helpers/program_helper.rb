module ProgramHelper
  def follow_program_button(personal_station, program)
    render 'programs/follow_button', personal_station: personal_station, program: program
  end

  def follow_link(personal_station, program)
    if program.followed_by_user?
      link_to station_program_path(personal_station, program), method: :delete,
        class: 'btn btn-follow' do
          yield
        end
    else
      link_to station_programs_path(personal_station, id: program.id), method: :post,
        class: 'btn btn-follow' do
          yield
        end
    end
  end

  def follow_status_class(program)
    return 'following' if program.followed_by_user?
    'not-following'
  end

  def active_season?(season, program, episode=nil)
    return season == episode.season_nr if episode
    program.current_season_nr == season
  end
end