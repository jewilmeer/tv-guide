class PagesController < ApplicationController
  # hompage
  def index
  end
  
  def show
    @page = Page.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound unless @page
  end
end