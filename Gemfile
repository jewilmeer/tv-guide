source 'http://rubygems.org'
ruby '1.9.3'

gem "rails", "~> 3.2.13"
gem 'mail'
gem 'pg'

# Bundle the extra gems:
gem 'mechanize', '~> 2.0.1'
gem 'squeel'
gem 'simple_form'
gem 'progress_bar'
gem 'tvdb_party', :git => 'git://github.com/jewilmeer/tvdb_party.git'
gem 'paperclip', '~> 3.0'
gem "aws-sdk", '~> 1.3.4'
gem 'newrelic_rpm'
gem 'airbrake'
gem 'user-agent'
gem 'haml'
gem 'will_paginate'
gem 'devise'

# background
gem 'sidekiq'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

# caching
gem "dalli"

group :assets do
  gem 'jquery-rails'
  gem 'coffee-rails'#, "~> 3.2.1"
  gem 'sass-rails'#, "  ~> 3.2.3"
  gem 'uglifier'
  gem 'compass-rails'
  gem 'bootstrap-sass'
  gem 'turbo-sprockets-rails3'
  gem 'font-awesome-sass-rails'
end

group :production do
  # replace webrick with thin
  gem 'unicorn'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'annotate'

  # test stuff
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem "factory_girl_rails"

  # help test stuff
  gem 'timecop'

  # verify
  gem 'simplecov', :require => false

  gem 'pry-rails'
  gem 'pry-debugger'
end

group :test do
  gem 'fakeweb'
end
