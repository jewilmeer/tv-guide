class Admin::PagesController < AdminAreaController
  
  before_filter :get_page, :only => [:edit, :update]
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
  end
  def update
    @page.update_attributes(params[:page])
    expire_page(page_path(@page))
    expire_page('/')
    flash[:notice] = 'Update completed'
    redirect_to([:admin, :pages])
  end
  
  def find_page
    @page = Page.find_by_name(params[:id])
    raise ActiveRecord::RecordNotFound unless @page
  end
end