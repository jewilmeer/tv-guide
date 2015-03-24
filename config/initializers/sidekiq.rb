Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://db.netflikker.nl:6379/12' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://db.netflikker.nl:6379/12' }
end