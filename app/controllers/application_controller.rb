class ApplicationController < ActionController::Base
  include Sellaband::Authentication

  protect_from_forgery
  layout Proc.new{|a| set_layout }
  
  def set_layout
    if params[:beta].present?
      if params[:beta].downcase == 'true'
        session[:beta] = true 
      elsif params[:beta] == false
        session.delete(:beta)
      end
    end
    
    session[:beta] ? 'simple' : 'application'
  end
end
