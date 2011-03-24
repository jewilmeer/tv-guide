# == Schema Information
# Schema version: 20101130174533
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  email               :string(255)     not null
#  password_salt       :string(255)     not null
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  oauth_uid           :string(255)
#  admin               :boolean(1)
#  trusted             :boolean(1)
#  login               :string(255)
#  crypted_password    :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#

class User < ActiveRecord::Base
  include Pacecar
  
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
  
  after_create :notify_of_registration
  before_update :notify_of_special_features
  
  # attr_accessible :login, :password, :password_confirmation
  
  def self.find_by_email_or_login login
    find_by_email(login) || find_by_login(login)
  end
  
  def apply_omniauth omni_auth 
    Rails.logger.debug omni_auth.inspect
    return false unless omni_auth && omni_auth['provider']
    authentications.build( :provider => omni_auth['provider'], :uid => (omni_auth['uid'] || nil) )
    # apply additional userinfo
    user_info  = omni_auth['user_info']
    self.email = user_info['email'] if email.blank?
    # facebook email grepping
    self.email = omni_auth['user_hash']['email'] if omni_auth['user_hash'] && email.blank?
    self.login = (user_info['username'] || user_info['login'] || user_info['nickname']) if login.blank?
  end

  def password_required?
    return false if crypted_password.present?
    (authentications.empty? || password.present?)
  end
  
  def to_param
    login.parameterize
  end
  
  def notify_of_registration
    AdminMailer.notify_of_registration( self ).deliver
  end
  
  # send an email to the user as they have been trusted. 
  # This will instruct them how to use the download functionality
  def notify_of_special_features
    UserMailer.trusted_notification( self ).deliver if self.trusted_changed? && self.trusted_was == false
  end
end
