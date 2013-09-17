require 'active_support/concern'

module Concerns
  module TokenAuthenticatableFilters
    extend ActiveSupport::Concern

    included do
      private

      # For this example, we are simply using token authentication
      # via parameters. However, anyone could use Rails's token
      # authentication features to get the token from a header.
      def authenticate_user_from_token!
        authentication_token = params[:authentication_token].presence
        user = authentication_token && User.find_by_authentication_token(authentication_token)

        if user
          # Notice we are passing store false, so the user is not
          # actually stored in the session and a token is needed
          # for every request. If you want the token to work as a
          # sign in token, you can simply remove store: false.
          sign_in user, store: false
        end
      end
    end
  end
end