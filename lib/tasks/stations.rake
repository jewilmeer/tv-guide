namespace :stations do
  desc 'create missing genre stations'
  task :genre => :environment do
    puts "Got #{Station.count} stations before"
    Genre.all.each do |g|
      Station.where(taggable_id: g.id, taggable_type: 'Genre').
        first_or_create(name: g.name)
    end
    puts "Got #{Station.count} stations after"
  end

  desc 'create missing user stations'
  task :user => :environment do
    puts "Got #{Station.count} stations before"
    User.all.each do |u|
      Station.where(taggable_id: u.id, taggable_type: 'User').
        first_or_create(name: "#{u.login}'s", user_id: u.id)
    end
    puts "Got #{Station.count} stations after"
  end
end