class Admin::PagesController < AdminAreaController

  # admin homepage
  def root
  end

  def index
    @pages = Page.all
    @page  = Page.new
  end
  
  def create
    Page.create(params[:page])
    redirect_to [:admin, :pages]
  end
end