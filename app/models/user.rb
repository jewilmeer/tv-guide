class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field          = :email # email is the login field
    c.validate_email_field = false
  end
  
  validates :login, :presence => true, :uniqueness => true, :format => /^[a-z-]+$/
  
  has_and_belongs_to_many :programs, :uniq => true
  has_and_belongs_to_many :episodes
  has_many :authentications
  
  # attr_accessible :login, :password, :password_confirmation
  
  def self.find_by_email_or_login login
    find_by_email(login) || find_by_login(login)
  end
  
  def apply_omniauth omni_auth 
    authentications.build( :provider => omni_auth['provider'], :uid => omni_auth['uid'] )
    # apply additional userinfo
    user_info  = omni_auth['user_info']
    self.email = user_info['email'] if email.blank?
    # facebook email grepping
    self.email = omni_auth['extra']['user_hash']['email'] if omni_auth['extra'] && omni_auth['extra']['user_hash'] && email.blank?
    self.login = (user_info['username'] || user_info['login'] || user_info['nickname']) if login.blank?
  end

  def password_required?
    (authentications.empty? || !password.blank?)
  end
  
  def to_param
    login.parameterize
  end
end
