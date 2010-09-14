class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field           = :email # email is the login field
  end
  
  validates :login, :presence => true, :uniqueness => true, :format => /^[a-z-]+$/i
  
  has_and_belongs_to_many :programs, :uniq => true
  has_and_belongs_to_many :episodes
  
  # attr_accessible :login, :password, :password_confirmation
  
  def to_param
    login.parameterize
  end
end
