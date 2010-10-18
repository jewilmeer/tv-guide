class ApplicationController < ActionController::Base
  include Sellaband::Authentication

  protect_from_forgery
end
