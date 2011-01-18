class AdminMailer < ActionMailer::Base
  default :from => "Digital tv guide<tvguide@jewilmeer.com>"

  def recipients users
    users.map{|user| "#{user.login}<#{user.email}>"} * ', '
  end
  
  def notify_of_registration user 
    @registered_user = user
    mail( :to => recipients(User.admin.all), :subject => 'You can now use \'special\' features' )
  end
  
end
