# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TvEpisodes::Application.initialize!

ActiveSupport::Dependencies.log_activity = true