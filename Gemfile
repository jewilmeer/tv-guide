source 'http://rubygems.org'
gem "rails", "3.2.0.rc1"
gem 'mail'
gem 'jquery-rails'
gem 'pg'

# Bundle the extra gems:
gem 'mechanize'

gem 'pacecar'
# used in admin
gem 'formtastic-bootstrap', :git => 'git://github.com/aaronbrethorst/formtastic-bootstrap'

# for deployment
# gem 'rubber'

# # terminal
gem 'progress_bar'

# # requirement for tvdb
gem 'tvdb_party', :git => 'git://github.com/jewilmeer/tvdb_party.git'

gem 'paperclip'
gem 'aws-s3'
gem 'newrelic_rpm'
gem 'airbrake'

# parsing user agent strings
gem 'user-agent'

# # caching
gem "dalli"

# # authentication
gem 'authlogic'#, :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
# gem 'omniauth', '>=0.2.6'

gem 'haml'
# Bundle gems for certain environments:
group :assets do
  gem 'coffee-rails', "~> 3.2.1"
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'uglifier'
end

group :production do 
  # replace webrick with thin
  gem 'unicorn'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'mysql2'
  gem 'heroku'
  gem 'taps'
  gem 'annotate'

  # gem 'spork'
  gem 'guard'
  # gem 'guard-spork'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  # gem 'guard-spin'

  # do always install these, but only load them if the requirement is met 
  gem 'rb-fsevent'#, :require => false unless RUBY_PLATFORM =~ /darwin/i
  # gem 'growl_notify'#, :require => false unless RUBY_PLATFORM =~ /darwin/i

  # test stuff
  gem "rspec-rails"
  # gem 'capybara', :branch => 'asset-pipeline-support'
  gem "factory_girl_rails"

  # help test stuff
  gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git'
  gem 'pickle'
  gem 'shoulda-matchers'
  gem 'rspec-instafail'

  # verify
  gem 'simplecov', :require => false
end

group :development do 
  gem 'cucumber-rails'
  gem 'reek'
end

# group :test do
#   gem 'capybara-webkit'
# end