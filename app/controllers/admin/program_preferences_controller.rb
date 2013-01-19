class Admin::ProgramPreferencesController < AdminAreaController
  before_filter :find_object, :except => [:index, :new, :create]

  def index
    @program_preferences = ProgramPreference.page params[:page]
    @program_preference  = ProgramPreference.new
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