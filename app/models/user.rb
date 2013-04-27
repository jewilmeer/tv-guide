class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :token_authenticatable,
    :trackable, :rememberable, :validatable

  has_many :program_preferences
  has_many :search_term_types, :through => :program_preferences
  has_many :programs, :through => :program_preferences
  has_and_belongs_to_many :episodes
  has_many :interactions, :dependent => :nullify
  has_many :stations

  before_update :notify_of_special_features
  before_save :ensure_authentication_token
  after_create :notify_of_registration
  after_create :create_personal_station

  validates :login, presence: true, uniqueness: true

  def self.find_by_email_or_login login
    find_by_email(login) || find_by_login(login)
  end

  def to_param
    login.parameterize
  end

  def notify_of_registration
    AdminMailer.notify_of_registration( self ).deliver
  end

  def create_personal_station
    self.stations.create taggable_type: 'User', taggable_id: self.id, name: "#{self.login}'s"
  end

  # send an email to the user as they have been trusted.
  # This will instruct them how to use the download functionality
  def notify_of_special_features
    UserMailer.trusted_notification( self ).deliver if self.trusted_changed? && self.trusted_was == false
  end

  def filtered_email
    self.email.downcase
  end

  alias :devise_valid_password? :valid_password?
  def valid_password?(password)
    begin
      super(password)
    rescue BCrypt::Errors::InvalidHash
      stretches = 20
      digest  = [password, password_salt].flatten.join('')
      stretches.times {digest = Digest::SHA512.hexdigest(digest)}
      return false unless digest == encrypted_password

      Rails.logger.info "User #{email} is using the old password hashing method, updating attribute."
      self.password = password
      self.password_salt = nil
      save
      true
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  email                :string(255)      not null
#  password_salt        :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  oauth_uid            :string(255)
#  admin                :boolean          default(FALSE)
#  trusted              :boolean          default(FALSE)
#  login                :string(255)
#  encrypted_password   :string(255)
#  authentication_token :string(255)
#  sign_in_count        :integer          default(0), not null
#  failed_attempts      :integer          default(0), not null
#  last_request_at      :datetime
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_login_ip        :string(255)
#  programs_count       :integer          default(0)
#  interactions_count   :integer          default(0)
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#

