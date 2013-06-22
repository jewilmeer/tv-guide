class AdminMailer < ActionMailer::Base
  default :from => "Digital TV guide<no-reply@netflikker.nl>"

  def recipients users
    users.map{|user| "#{user.login}<#{user.email}>"} * ', '
  end

  def notify_of_registration user
    @registered_user = user
    admins = User.where('admin = ?', true)
    return unless admins.any?
    mail :to => recipients(admins), :subject => 'New unknown user, do you want to trust him/her?'
  end
end
