namespace :stations do
  desc 'create missing genre stations'
  task :genre => :environment do
    puts "Got #{Station.count} stations before"
    Genre.all.each do |g|
      station = Station.where(taggable_id: g.id, taggable_type: 'Genre').
        first_or_create(name: g.name)

      if g.programs
        programs = station.programs
        g.programs.each do |program|
          p "trying to add #{program.name}"
          station.programs <<(program) unless programs.include? program
        end
      end
    end
    puts "Got #{Station.count} stations after"
  end

  desc 'create missing user stations'
  task :user => :environment do
    puts "Got #{Station.count} stations before"
    User.all.each do |u|
      station = Station.where(taggable_id: u.id, taggable_type: 'User').
        first_or_create(name: "#{u.login}'s", user_id: u.id)

      if u.programs
        programs = station.programs
        u.programs.each do |program|
          unless programs.include? program
            puts "adding #{program.name} to #{station.name}"
            station.programs << program
          end
        end
      end
    end
    puts "Got #{Station.count} stations after"
  end
end