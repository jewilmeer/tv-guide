namespace :refactor do
  task :migrate_season_nrs_to_episodes => :environment do
    Program.update_all(['time_zone_offset = ?', 'Central Time (US & Canada)'])
    Episode.where('season_nr IS NULL').all(:include => :season).each do |episode|
      episode.update_attribute(:season_nr, episode.season.nr)
    end
    Episode.delete_all('episodes.season_nr = 0')
    Season.delete_all('seasons.nr = 0')
    Program.where('programs.max_season_nr IS NULL').where('programs.current_season_nr IS NULL').all.each do |program|
      program.max_season_nr     = program.episodes.by_season_nr(:desc).first.season_nr
      program.current_season_nr = program.episodes.last_aired.first.try(:season_nr) || 1
      program.save
    end
  end
  
  task :add_tvdb_id_for_episodes => :environment do 
    Program.all.each do |program|
      result = Episode.tvdb_client.get_all_episodes_by_id( program.tvdb_id )
      result.each do |tvdb_episode|
        next if tvdb_episode.season_number.to_i == 0 || tvdb_episode.number.to_i == 0
        episode = program.episodes.find_by_season_nr_and_nr( tvdb_episode.season_number, tvdb_episode.number )
        if episode
          episode.tvdb_id         = tvdb_episode.id
          episode.program_name    = program.name
          episode.tvdb_program_id = program.tvdb_id
          episode.save if episode.changed?
        else
          puts "episode not found: #{program.name} S#{tvdb_episode.season_number}E#{tvdb_episode.number}"
        end
      end
    end
  end
  
  task :remove_unwanted_episodes => :environment do
    Episode.delete_all('nr = 0')
  end
  task :init_program_images => :environment do
    Program.all.map(&:get_images)
  end
end

namespace :program do
  task :full_update => :environment do
    Program.all.map(&:tvdb_full_update)
  end
end