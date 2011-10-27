source 'http://rubygems.org'
gem "rails", "~> 3.1.1"
gem 'mail'
gem 'jquery-rails'

# Bundle the extra gems:
gem 'mechanize'
# gem 'logging'
# gem 'file-utils'
gem 'pacecar'
# gem 'dynamic_form'#, :git => 'http://github.com/rails/dynamic_form.git'
# gem 'typhoeus'
# gem 'activeadmin'

# used in admin
gem 'formtastic'#, '~>1'


# # terminal
gem 'progress_bar'

# # search
# gem 'thinkingtank'

# # requirement for tvdb
gem 'tvdb_party', :git => 'git://github.com/jewilmeer/tvdb_party.git'

# gem 'hpricot'
gem 'paperclip'
gem 'aws-s3'
gem 'newrelic_rpm'
# # caching
gem "dalli"

# # authentication
gem 'authlogic'#, :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
gem 'omniauth', '>=0.2.6'

gem 'haml'
# # Bundle gems for certain environments:

group :assets do
  gem 'coffee-rails', "~> 3.1.0"
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'uglifier'
end

group :production do 
  gem 'pg'
  # replace webrick with thin
  gem 'unicorn'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'mysql2'
  gem 'heroku'
  gem 'taps'
  gem 'annotate'

  gem 'spork', '~> 0.9.0rc9'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-cucumber'
  gem 'guard-rspec'

  # do always install these, but only load them if the requirement is met 
  gem 'rb-fsevent'#, :require => false unless RUBY_PLATFORM =~ /darwin/i
  gem 'growl_notify'#, :require => false unless RUBY_PLATFORM =~ /darwin/i

  # test stuff
  gem "rspec-rails"
  gem 'capybara', :branch => 'asset-pipeline-support'
  gem "factory_girl_rails"

  # help test stuff
  gem 'database_cleaner'
  gem 'pickle'
  gem 'shoulda-matchers'

  # verify
  gem 'simplecov', :require => false
end

group :development do 
  gem 'cucumber-rails'
  gem 'rspec-instafail'
end

group :test do
  gem 'capybara-webkit'
end