class User::ProgramPreferencesController < UserAreaController
  
  def index
    @program_preferences = current_user.program_preferences.all#.includes(:program)#.included(:program)
    @search_term_types   = SearchTermType.scoped
  end
  
  def create
    if params[:program_preference][:program_id]
      logger.debug "params[:program_preference]: #{params[:program_preference].inspect}"
      current_user.program_preferences.create( params[:program_preference] )
      respond_to do |format|
        format.html { redirect_to user_programs_path(current_user), :notice => 'Program Added' }
        format.js { flash[:notice] = 'Program added' }
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