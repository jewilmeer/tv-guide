class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field             = :email # email is the login field
    c.validate_email_field    = false
    c.validate_password_field = false
  end
  
  validates :login, :presence => true, :uniqueness => true, :format => /^[a-z-]+$/
  validates :password, :presence => true, :confirmation => true, :if => :password_required?
  validates :password_confirmation, :presence => true, :if => :password_required?
  
  has_and_belongs_to_many :programs, :uniq => true
  has_and_belongs_to_many :episodes
  has_many :authentications
  has_many :interactions, :dependent => :nullify
  
  # attr_accessible :login, :password, :password_confirmation
  
  def self.find_by_email_or_login login
    find_by_email(login) || find_by_login(login)
  end
  
  def apply_omniauth omni_auth 
    return false unless omni_auth && omni_auth['provider'] && omni_auth['uid']
    authentications.build( :provider => omni_auth['provider'], :uid => omni_auth['uid'] )
    # apply additional userinfo
    user_info  = omni_auth['user_info']
    self.email = user_info['email'] if email.blank?
    # facebook email grepping
    self.email = omni_auth['user_hash']['email'] if omni_auth['user_hash'] && email.blank?
    self.login = (user_info['username'] || user_info['login'] || user_info['nickname']) if login.blank?
  end

  def password_required?
    (authentications.empty? || !password.blank?)
  end
  
  def to_param
    login.parameterize
  end
end
