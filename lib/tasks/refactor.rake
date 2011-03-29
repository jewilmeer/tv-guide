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
end