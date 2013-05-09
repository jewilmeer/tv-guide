class UserAreaController < ApplicationController
  def user
    User.find_by_login!(params[:user_id])
  end
end