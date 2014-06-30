CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => Rails.application.secrets.aws.access_key_id,     # required
    :aws_secret_access_key  => Rails.application.secrets.aws.secret_access_key, # required
    :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = Rails.env.production? ? 'tv-guide' : 'tv-guide-dev' # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
