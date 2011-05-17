class User::ProgramPreferencesController < UserAreaController
  
  def index
    @program_preferences = current_user.program_preferences.all#.includes(:program)#.included(:program)
    @search_term_types   = SearchTermType.scoped
  end
  
  def create
    if params[:id]
      logger.debug "has id... #{__LINE__}"
      current_user.program_preferences.create( :program_id => params[:id], search_term_type_id => params[:search_term_type] )
      respond_to do |format|
        format.html { redirect_to user_programs_path(current_user), :notice => 'Program Added' }
        format.js { render :text => 'program added' }
      end
    elsif params[:tvdb_id]
      logger.debug "has id... #{__LINE__}"
      program = Program.find_or_create_by_tvdb_id(params[:tvdb_id])
      program.program_preferences.create( :user => current_user, :search_term_type_id => params[:search_term_type_id])
      respond_to do |format|
        format.html { render :text => 'no no no' }
        format.js   { render :text => "document.location.href = '#{user_programs_path(current_user)}';"}
      end
      
    else
      logger.debug "Needs a suggestion... #{__LINE__}"
      respond_to do |format|
        format.html { render :text => 'no no no' }
        format.js   { render :text => "document.location.href = '#{suggest_programs_path({:q => params[:q]})}';"}
      end
    end
  end
  
end