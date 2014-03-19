source 'http://rubygems.org'

gem "rails", "~> 4.0.0"
gem 'mail'
gem 'pg'
gem 'foreigner'
# gem 'immigrant' #add missing foreign keys

# Bundle the extra gems:
gem 'mechanize'
gem 'simple_form'
gem 'tvdb_party', :git => 'git://github.com/jewilmeer/tvdb_party.git'
# paperclip validations suck bigtime: https://github.com/thoughtbot/paperclip#security-validations is not working
gem 'paperclip', '~> 3.0'
gem 'carrierwave'
gem "aws-sdk"
gem 'airbrake'
gem 'user-agent'
gem 'haml'
gem 'will_paginate'
# strong params doesn't like me in production
gem 'devise'
gem 'friendly_id'
gem 'appsignal'

# background
gem 'sidekiq'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

# assets
gem 'jquery-rails'
gem 'coffee-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'bootstrap-sass', '~> 2.0'
gem 'bootswatch-rails'
gem 'font-awesome-sass-rails'

gem 'pry-rails'

group :production do
  gem 'newrelic_rpm'
  gem 'dalli'
end

group :development, :test do
  gem 'thin'
  gem 'letter_opener'

  # test stuff
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem "factory_girl_rails"

  # help test stuff
  gem 'timecop'
end

group :development do
  gem 'annotate', github: 'ctran/annotate_models'
end

group :test do
  gem 'fakeweb'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'

  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
end
