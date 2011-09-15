class UserAreaController < ApplicationController
  before_filter :get_user
  
  def get_user
    id = params[:user_id] || params[:id]
    @user = User.find_by_login(id)
    
    raise ActiveRecord::RecordNotFound unless @user
  end
end