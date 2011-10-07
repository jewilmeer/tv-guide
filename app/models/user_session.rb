class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_email_or_login
  
  def to_key
     self.keys.to_a
  end
  
  def single_access_allowed_request_types
    ['application/x-nzb', "application/rss+xml", "application/atom+xml"]
  end
end