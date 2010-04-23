class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :database_authenticatable, :trackable, :timeoutable, :lockable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
