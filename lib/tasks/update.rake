namespace :update do

  task :do => [:link_episodes_to_programs, :add_tvdb_info]
  
  task :link_episodes_to_programs => :environment do
    Episode.program_id_missing.all.each do |e|
      e.update_attribute(:program_id, e.season.program_id)
    end
  end
  
  task :add_tvdb_info => :environment do
    Program.find_by_search_term("house").update_attribute('name', 'House')
    Program.destroy(11) if Program.find_by_id(11)
    Program.find(25).update_attribute(:name, "Zeke & Luther")
    changes = []
    Program.tvdb_id_missing.all.map{|p| 
      p.find_additional_info
      changes << p.changes if p.changed? 
      p.save
    }
    puts changes.inspect
  end
end