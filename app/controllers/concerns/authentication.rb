require 'active_support/concern'

module Concerns
  module Authentication
    extend ActiveSupport::Concern

    def require_trust
      if current_user.try(:trusted?)
        true
      else
        redirect_to new_user_session_path, flash: { error: t('flash.error.trust_required') }
      end
    end

    def require_admin
      if current_user.try(:admin?)
        true
      else
        redirect_to new_user_session_path, flash: { error: t('flash.error.admin_required') }
      end
    end
  end
end