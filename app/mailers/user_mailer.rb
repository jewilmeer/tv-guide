class UserMailer < ActionMailer::Base
  default :from => "Digital TV Guide <mail@jewilmeer.com>"
  
  def pretty_name user
    "#{user.login} <#{user.email}>"
  end
  
  def registration_confirmation user
    @user = user
    mail( :to => pretty_name(user), :subject => 'Welcome to Digital TV Guide!' )
  end
  
  def trusted_notification user 
    @user = user
    mail( :to => pretty_name(user), :subject => 'You can now use \'special\' features' )
  end
end
