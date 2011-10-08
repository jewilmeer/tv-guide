TvEpisodes::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.cache_store = :dalli_store

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'tv-episodes.local' }
  config.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'tv-epsisodes.local',
    :user_name            => 'jewilmeer',
    :password             => '1Bananen',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }
  
  # config.cache_store = :mem_cache_store
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # speed  up development. Better disable this for front-end development
  # config.serve_static_assets = true
  # config.static_cache_control = "public, max-age=3600"

end
