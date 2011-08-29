class User::ProgramPreferencesController < UserAreaController
  
  def index
    @program_preferences = current_user.program_preferences.all#.includes(:program)#.included(:program)
    @search_term_types   = SearchTermType.scoped
  end
  
  def create
    if params[:program_preference] && params[:program_preference][:program_id].present?
      logger.debug "params[:program_preference]: #{params[:program_preference].inspect}"
      current_user.program_preferences.create( params[:program_preference] )
      respond_to do |format|
        format.html { redirect_to user_programs_path(current_user), :notice => 'Program Added' }
        format.js { flash[:notice] = 'Program added' }
      end
    elsif params[:tvdb_id].present? && params[:search_term_type_id].present?
      program = Program.find_or_create_by_tvdb_id(params[:tvdb_id])
      current_user.program_preferences.create( :program => program, :search_term_type_id => params[:search_term_type_id])
      respond_to do |format|
        format.html { render :text => 'no no no' }
        format.js   { render :text => "document.location.href = '#{user_programs_path(current_user)}';"}
      end
    else
      logger.debug "Needs a suggestion..."
      respond_to do |format|
        format.html { render :text => 'no no no' }
        format.js   { render :text => "document.location.href = '#{suggest_programs_path({:q => params[:q]})}';"}
      end
    end
  end
  
end