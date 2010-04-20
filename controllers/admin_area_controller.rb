class AdminAreaController < ApplicationController
  before_filter :require_admin
  
  def index
    render 'admin/index'
  end
end