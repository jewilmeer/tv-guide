class Admin::ProgramPreferencesController < AdminAreaController
  helper_method :sort_column, :sort_direction
  before_filter :find_object, :except => [:index, :new, :create]

  def index
    @program_preference  = ProgramPreference.new
    @program_preferences = ProgramPreference.order(sort_column + ' ' + sort_direction).paginate :per_page => 25, :page => params[:page]
    respond_to do |format|
      format.html {}
      format.js   { render :text => render_to_string( @program_preferences ) }
    end
  end

  def create
    pp = ProgramPreference.create(params[:program_preference])
    redirect_to edit_admin_program_preferences_path, :notice => "Created succesfully!"
  end
  
  def update
    @program_preference.update_attributes params[:program_preference]
    redirect_to :back, :notice => 'Updated'
  end
  
  protected
  def find_object
    @program_preference = ProgramPreference.find( params[:id] )
  end
  
  def sort_column
    ProgramPreference.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end