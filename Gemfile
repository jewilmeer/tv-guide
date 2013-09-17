source 'http://rubygems.org'

gem "rails", "~> 4.0.0"
gem 'mail'
gem 'pg'

# Bundle the extra gems:
gem 'mechanize'
gem 'simple_form', '3.0.0.rc'
gem 'tvdb_party', :git => 'git://github.com/jewilmeer/tvdb_party.git'
gem 'paperclip'
gem 'carrierwave'
gem "aws-sdk"
gem 'exceptional'
gem 'user-agent'
gem 'haml'
gem 'will_paginate'
# strong params doesn't like me in production
gem 'devise'
gem 'friendly_id', '5.0.0.beta3'

# background
gem 'sidekiq'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

gem 'jquery-rails'
gem 'coffee-rails'
gem 'sass-rails'
gem 'uglifier'
gem "compass-rails", github: "milgner/compass-rails", branch: "rails4"
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'font-awesome-sass-rails'

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

  gem 'pry-rails'
  gem 'pry-debugger'
end

group :development do
  gem 'annotate', github: 'ctran/annotate_models'
end

group :test do
  gem 'fakeweb'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end
