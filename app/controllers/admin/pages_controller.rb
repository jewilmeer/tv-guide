class Admin::PagesController < AdminAreaController
  helper_method :sort_column, :sort_direction
  before_filter :get_page, :only => [:edit, :update]

  # admin homepage
  def root
  end

  def index
    @pages = Page.order(sort_column + ' ' + sort_direction)#.paginate :per_page => 30, :page => params[:page]
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
  
  protected
  def get_page
    @page = Page.find_by_permalink!(params[:id])
  end

  def sort_column
    Page.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end