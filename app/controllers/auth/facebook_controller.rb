class Auth::FacebookController < ApplicationController
  before_filter :verify_call
  skip_before_filter :verify_authenticity_token
  
  
  protected 
  def verify_call
    
  end
end