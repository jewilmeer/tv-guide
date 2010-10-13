Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :facebook, '117884434913747', '3dfbad4725299f687198a5e77d29452f'
  # provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
