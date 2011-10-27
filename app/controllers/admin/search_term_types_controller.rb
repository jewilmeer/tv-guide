class Admin::SearchTermTypesController < AdminAreaController
  helper_method :sort_column, :sort_direction
  before_filter :get_object, :except => [:index, :new, :create]

  def index
    @search_term_type   = SearchTermType.new
    @search_term_types  = SearchTermType.by_name.order(sort_column + ' ' + sort_direction)#.paginate :per_page => 25, :page => params[:page]
    
    respond_to do |format|
      format.html { }
      format.js   { render :text => render_to_string( @programs ) }
    end
  end
  
  def create
    @search_term_type = SearchTermType.new params[:search_term_type]
    if @search_term_type.save
      redirect_to [:admin, :search_term_types], :notify => "Search term saved!"
    else
      flash.now "WRONG!"
      render :edit
    end
  end
  
  def update
    if @search_term_type.update_attributes( params[:search_term_type] )
      redirect_to [:admin, :search_term_types], :notify => 'Saved!'
    else
      render :edit
    end
  end
  
  protected
  def get_object
    @search_term_type = SearchTermType.find( params[:id] )
  end
  
  def sort_column
    SearchTermType.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end