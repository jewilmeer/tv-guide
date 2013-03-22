require 'simplecov'

ENV['RAILS_ENV'] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller

  # short factory_girl syntax
  config.include FactoryGirl::Syntax::Methods
end
