source 'http://rubygems.org'

gem "rails", "~> 4.0"
gem 'mail'
gem 'pg'

# search
gem 'pg_search'

# Bundle the extra gems:
gem 'mechanize'
gem 'simple_form'
gem 'tvdb_party', github: 'jewilmeer/tvdb_party'
# paperclip validations suck bigtime: https://github.com/thoughtbot/paperclip#security-validations is not working
gem 'paperclip'
gem 'carrierwave'
gem 'fog'
gem "aws-sdk"
gem 'airbrake'
gem 'user-agent'
gem 'haml'
gem 'will_paginate'
# strong params doesn't like me in production
gem 'devise'
gem 'friendly_id'

# background
gem 'sidekiq'
gem 'slim'
gem 'sinatra'

# assets
gem 'jquery-rails'
gem 'coffee-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'bootstrap-sass', '~> 2.0'
gem 'bootswatch-rails', '~> 3.1.0'
gem 'font-awesome-sass-rails'
gem 'sprockets', '2.11.0' # because of undefined method `environment' for nil:NilClass error

gem 'dotenv-rails'

group :production do
  gem 'newrelic_rpm'
  gem 'dalli'
end

group :development, :test do
  gem 'thin'
  gem 'letter_opener'

  # test stuff
  gem 'rspec-rails'
  gem "factory_girl_rails"

  # help test stuff
  gem 'timecop'

  gem 'pry-rails'
end

group :development do
  gem 'annotate', github: 'ctran/annotate_models'
  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  gem 'fakeweb'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end
