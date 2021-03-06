class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  protected

  # my custom field is :login
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:login,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:login,
        :email, :password, :password_confirmation, :current_password)
    end
  end

end
