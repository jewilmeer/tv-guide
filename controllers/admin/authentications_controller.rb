class Admin::AuthenticationsController < AdminAreaController
  def index
    @authentications = Authentication.all
  end
end