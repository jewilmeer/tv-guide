Airbrake.configure do |config|
  config.api_key = '7edf1eaaec7f2db891dfd3da321d4523'
  config.host    = 'ladress-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end

