task :cron => :environment do
  Program.all.map(&:add_new_episodes)
end