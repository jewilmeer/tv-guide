raw_config = File.read( File.join(Rails.root, "config/app_config.yml") )
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

