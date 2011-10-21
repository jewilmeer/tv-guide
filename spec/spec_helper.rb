require 'rubygems'
require 'spork'

Spork.prefork do
  require 'simplecov'
  SimpleCov.command_name "RSpec"
  SimpleCov.coverage_dir 'coverage/'
  SimpleCov.start 'rails'

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require "authlogic/test_case"
  
  include Authlogic::TestCase

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.start

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    # short factory_girl syntax
    config.include Factory::Syntax::Methods
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  DatabaseCleaner.clean
end
