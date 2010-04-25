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
  
  def edit
    @page = Page.find(params[:id])
  end
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    expire_page(page_path(@page))
    expire_page('/')
    flash[:notice] = 'Update completed'
    redirect_to([:admin, :pages])
  end
end