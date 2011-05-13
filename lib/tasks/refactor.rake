require 'progress_bar'
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
  
  desc 'add tvdb_ids to episodes'
  task :add_tvdb_id_for_episodes => :environment do 
    puts "==="*20
    puts "==="*20
    puts "=== ADDING TVDB IDS"
    puts "==="*20
    puts "==="*20
    Program.all.each do |program|
      puts "==="*20
      puts "==="*20
      puts "=== ADDING TVDB IDS FOR #{program.name}"
      puts "==="*20
      puts "==="*20
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
    Program.all.map do |p|
      puts "==="*20
      puts "==="*20
      puts "=== GETTING IMAGES FOR #{p.name}"
      puts "==="*20
      puts "==="*20
      
      p.get_images
    end
  end

  desc 'Upgrade to new api'
  task :new_api_update => [:add_tvdb_id_for_episodes, :remove_unwanted_episodes, :init_program_images]
end

namespace :update do
  desc 'update all programs'
  task :programs => :environment do
    puts Program.count
    bar = ProgressBar.new( Program.count, :bar, :counter, :rate )

    Program.by_updated_at(:asc).all.map do |p|
      p.tvdb_full_update
      bar.increment!
    end
  end
  
  desc 'find missing episode images'
  task :missing_episode_images => :environment do
    puts "Found #{Episode.where('image_id IS NULL').last_aired.count} episodes missing episode images"
    Episode.where('image_id IS NULL').last_aired.limited(300).each do |episode|
      episode.tvdb_update
    end
  end
  
  desc 'update the aired episodes'
  task :aired_episodes => :environment do
    puts "updating #{Episode.last_aired.count} episodes"
    Episode.last_aired.each do |episode|
      puts "updating #{episode.program_name} - #{episode.season_and_episode} - #{episode.title}"
      episode.tvdb_update
      puts "Downloading nzbs #{episode.program_name} - #{episode.season_and_episode} - #{episode.title}"
      episode.download_all
    end
  end

  desc 'update the 50 last aired episodes'
  task :last_aired_episodes => :environment do
    Episode.last_aired.limited(50).each do |episode|
      puts "updating #{episode.program_name} - #{episode.season_and_episode} - #{episode.title}"
      episode.tvdb_update
      puts "Downloading nzbs #{episode.program_name} - #{episode.season_and_episode} - #{episode.title}"
      episode.download_all
    end
  end
end



namespace :app do
  task :update_counters => :cleanup_duplicates do
    Program.all.each do |program|
      # program.update_attribute(:users_count, program.users.count)
      Program.reset_counters program.id, :interactions, :program_preferences
    end
    User.all.each do |user|
      User.reset_counters user.id, :interactions, :program_preferences
      # user.update_attribute :programs_count, user.programs.count
    end
  end
  
  task :cleanup_duplicates => :environment do
    puts 'checking duplicates'
    ProgramsUser.connection.select_all("SELECT user_id, program_id, COUNT(*) as count FROM programs_users GROUP BY program_id, user_id HAVING count > 1").each do |program_user|
      puts "removing duplicate: #{program_user['program_id']}::#{program_user['user_id']}"
      ProgramsUser.connection.delete("DELETE FROM programs_users WHERE program_id=#{program_user['program_id']} AND user_id=#{program_user['user_id']} LIMIT 1")
    end 
  end
end

namespace :search_term do
  desc 'add default search terms'
  task :add_default_terms => :environment do
    SearchTermType.create( :name => 'Low Res',    :search_term => '-720 -1080', :code => 'low_res')
    SearchTermType.create( :name => 'HD (720p)',  :search_term => '720',        :code => 'hd')
    SearchTermType.create( :name => 'Full HD',    :search_term => '1080 -720',  :code => 'full_hd')
    Download.update_all(['download_type=?', 'hd'], {:download_type => 'nzb_hd'})
    c = Configuration.default
    c.filter_data[:nzb][:params]['minsize'] = 100
    c.save!
  end
  
  desc 'convert all program<->user connections to new setup'
  task :add_program_preferences => :add_default_terms do
    User.all.each do |user|
      user.programs.each do |program|
        program.program_preferences.create( :user => user, :search_term_type => SearchTermType.default)
      end
    end
  end
end
task :search_term => 'search_term:add_program_preferences'