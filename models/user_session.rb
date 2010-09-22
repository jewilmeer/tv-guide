class UserSession < Authlogic::Session::Base
  # single_access_allowed_request_types = ['application/x-nzb']
  def to_key
     self.keys.to_a
  end
  
  def single_access_allowed_request_types
    ['application/x-nzb', "application/rss+xml", "application/atom+xml"]
  end
end