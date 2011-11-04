class ApplicationController < ActionController::Base
  include Sellaband::Authentication

  protect_from_forgery
  
  layout 'simple'  
  before_filter :set_timezone

  def set_timezone
    Time.zone = 'Amsterdam'
  end
end
