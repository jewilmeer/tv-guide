require File.expand_path('../boot', __FILE__)

require 'rails/all'
Bundler.require :default, Rails.env

module TvEpisodes
  class Application < Rails::Application
    # Add additional load paths for your own custom dirs
    config.autoload_paths += %W(#{config.root}/lib)

    config.time_zone = 'Amsterdam'
    I18n.enforce_available_locales = true
  end
end
