source 'http://rubygems.org'

gem "rails", "~> 3.2.0"
gem 'mail'
gem 'pg'

# Bundle the extra gems:
gem 'mechanize'
gem 'squeel'
gem 'simple_form'
gem 'progress_bar'
gem 'tvdb_party', :git => 'git://github.com/jewilmeer/tvdb_party.git'
gem 'paperclip'
gem 'carrierwave'
gem "aws-sdk"
gem 'newrelic_rpm'
gem 'exceptional'
gem 'user-agent'
gem 'haml'
gem 'will_paginate'
gem 'devise'
gem 'friendly_id'

# background
gem 'sidekiq'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

group :assets do
  gem 'jquery-rails'
  gem 'coffee-rails'#, "~> 3.2.1"
  gem 'sass-rails'#, "  ~> 3.2.3"
  gem 'uglifier'
  gem 'compass-rails'
  gem 'bootstrap-sass'
  gem 'bootswatch-rails'
  gem 'turbo-sprockets-rails3'
  gem 'font-awesome-sass-rails'
end

group :production do
  # replace webrick with thin
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'annotate'
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

group :test do
  gem 'fakeweb'
end
