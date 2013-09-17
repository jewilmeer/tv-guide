class ApplicationController < ActionController::Base
  include Concerns::Authentication, Concerns::TokenAuthenticatableFilters

  protect_from_forgery

  before_filter :set_timezone
  def set_timezone
    Time.zone = 'Amsterdam'
  end
end