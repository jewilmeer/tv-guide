require 'active_support/concern'

class AccessDenied < StandardError; end

module Concerns
  module Authentication
    extend ActiveSupport::Concern

    def require_trust
      raise AccessDenied unless current_user.try(:trusted?)
      true
    end

    def require_admin
      raise AccessDenied unless current_user.try(:admin?)
      true
    end
  end
end