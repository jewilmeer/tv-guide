class PagesController < ApplicationController
  # hompage
  def index
  end
  
  def show
    @page = Page.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @page
  end
end