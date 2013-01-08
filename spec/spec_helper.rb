require 'rubygems'

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

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  # short factory_girl syntax
  config.include FactoryGirl::Syntax::Methods

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
