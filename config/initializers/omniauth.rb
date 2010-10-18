Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'Zmi2YRTiPjLKf8SiMViS5w', 'nG2Z9BnbxmalgTyoRhvnHIqaapjZ52J8XOC7vrr36zA'
  provider :facebook, '154334824603268', '47be4747483dc88821bcfe6a0e6ea6d6' if Rails.env.development?
  provider :facebook, '117884434913747', '3dfbad4725299f687198a5e77d29452f' if Rails.env.production?
  # provider :linked_in, 'dtjAOZlJZLHHCiPlBYtgRix2XXBum9fEDrXBZg_XlOVqqIZXA38cmHpLFSd0rakK', 'G96wpyIGOMILPxtLBLG-9Y-FiIEnr0bYbI2vp8pLn7cLNizwiNCEVMaX22j-z8JE'
  if Rails.env.production?
    require 'openid/store/memcache'
    # provider :open_id, OpenID::Store::Memcache.new
    provider :open_id, OpenID::Store::Memcache.new, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
    provider :open_id, OpenID::Store::Memcache.new, :name => 'hyves', :identifier => 'https://www.hyves.nl'
    provider :open_id, OpenID::Store::Memcache.new, :name => 'yahoo', :identifier => 'yahoo.com'
    provider :open_id, OpenID::Store::Memcache.new, :name => 'myspace', :identifier => 'myspace.com'
    provider :open_id, OpenID::Store::Memcache.new, :name => 'aol', :identifier => 'aol.com'
  else
    require 'openid/store/filesystem'
    # provider :open_id, OpenID::Store::Filesystem.new('/tmp')
    provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
    provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'hyves', :identifier => 'https://www.hyves.nl'
    provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
    provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'myspace', :identifier => 'myspace.com'
    provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'aol', :identifier => 'aol.com'
  end
end
AUTH_PROVIDERS    = %w(twitter facebook open_id google hyves yahoo myspace)
