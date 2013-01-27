class ApplicationController < ActionController::Base
  include Concerns::Authentication

  protect_from_forgery

  before_filter :set_timezone
  def set_timezone
    Time.zone = 'Amsterdam'
  end
end