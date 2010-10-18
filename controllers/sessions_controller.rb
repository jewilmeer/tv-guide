class SessionsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      @user_session = UserSession.create( authentication.user )
      redirect_to [authentication.user, :programs], :notice => 'Login successful'
    elsif current_user #create new connection
      current_user.apply_omniauth omniauth
      current_user.save
      redirect_to [current_user, :programs], :notice => 'External service added'
    else
      user = User.new
      user.apply_omniauth omniauth
      if user.save!
        redirect_to [user, :programs], :notice => 'Registration successful'
      else
        session[:omniauth] = omniauth
        redirect_to new_user_path
      end
    end
  end
end
