namespace :migrate do
  task :downloads => :environment do
    episode_scope = Episode.nzb_file_name_present
    nr_of_objects = episode_scope.count
    puts "Converting #{nr_of_objects} downloads"
    pbar = ProgressBar.new(nr_of_objects)
    episode_scope.each do |episode|
      begin
        download = episode.downloads.build(:origin => 'unknown', :site => 'unknown', :download_type => 'nzb_hd')
        download.download = episode.nzb
        download.save
      rescue StandardError => e
        Rails.logger.debug e
      end
      pbar.increment!
    end
  end
end