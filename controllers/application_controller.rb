class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    case resource.class.name
    when 'User'
      programs_path
    when 'Admin'
      admin_root_path
    end
  end
  
end
