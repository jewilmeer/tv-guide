source 'http://rubygems.org'
# ruby '1.9.3'

gem "rails", "~> 4.0.0.rc2"
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
gem 'devise', github: 'plataformatec/devise'
gem 'friendly_id', github: 'FriendlyId/friendly_id', branch: :master

# background
gem 'sidekiq'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

gem 'jquery-rails'
gem 'coffee-rails'#, "4.0.0.rc1"
gem 'sass-rails', "4.0.0.rc2"
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

  # verify
  gem 'simplecov', :require => false

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
