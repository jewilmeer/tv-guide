class AdminMailer < ActionMailer::Base
  default :from => "Digital TV guide<tvguide@jewilmeer.com>"

  def recipients users
    users.map{|user| "#{user.login}<#{user.email}>"} * ', '
  end

  def notify_of_registration user
    @registered_user = user
    mail( :to => recipients(User.where('admin = ?', true).all), :subject => 'New unknown user, do you want to trust him/her?' )
  end

end
