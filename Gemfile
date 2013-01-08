source 'http://rubygems.org'
ruby '1.9.3'

gem "rails", "~> 3.2.6"
gem 'mail'
gem 'jquery-rails'
gem 'pg'

# Bundle the extra gems:
gem 'mechanize', '~> 2.0.1'

gem 'pacecar'
# used in admin
gem 'formtastic-bootstrap'

# for deployment
# gem 'rubber'

# # terminal
gem 'progress_bar'

# # requirement for tvdb
gem 'tvdb_party', :git => 'git://github.com/jewilmeer/tvdb_party.git'

gem 'paperclip', '~> 3.0'
gem "aws-sdk", '~> 1.3.4'
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
  gem 'coffee-rails'#, "~> 3.2.1"
  gem 'sass-rails'#, "  ~> 3.2.3"
  gem 'uglifier'
end

group :production do
  # replace webrick with thin
  gem 'unicorn'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'heroku'
  gem 'taps'
  gem 'annotate'

  # test stuff
  gem "rspec-rails"
  gem "factory_girl_rails"

  # help test stuff
  gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git'
  gem 'shoulda-matchers'
  gem 'rspec-instafail'

  # verify
  gem 'simplecov', :require => false

  gem 'pry'
end
