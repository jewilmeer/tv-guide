source 'http://rubygems.org'

gem "rails", "~> 4.0.0.rc2"
gem 'mail'
gem 'pg'

# Bundle the extra gems:
gem 'mechanize'
# gem 'squeel'
gem 'simple_form', '3.0.0.rc'
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
gem 'friendly_id', github: 'FriendlyId/friendly_id', branch: :rails4

# background
gem 'sidekiq'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

# group :assets do
  gem 'jquery-rails'
  gem 'coffee-rails'#, "4.0.0.rc1"
  gem 'sass-rails', "4.0.0.rc2"
  gem 'uglifier'
  gem "compass-rails", github: "milgner/compass-rails", branch: "rails4"
  gem 'bootstrap-sass'
  gem 'bootswatch-rails'
  gem 'font-awesome-sass-rails'
# end

group :production do
  # replace webrick with thin
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'thin'
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
