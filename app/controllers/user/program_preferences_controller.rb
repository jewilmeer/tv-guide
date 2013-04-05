class User::ProgramPreferencesController < UserAreaController
  def index
    @program_preferences = current_user.program_preferences.all#.includes(:program)#.included(:program)
    @search_term_types   = SearchTermType.scoped
  end

  def new
    @program_preference = current_user.program_preferences.build
    @program_preference.search_term_type_id= SearchTermType.find_by_code('hd')
  end

  def create
    # maybe programs#show?
    if params[:program_preference] && params[:program_preference][:program_id].present?
      current_user.program_preferences.create( params[:program_preference] )
      respond_to do |format|
        format.html { redirect_to user_programs_path(current_user), :notice => 'Program Added' }
        format.js { flash[:notice] = 'Program added' }
      end
    # from search page
    elsif params[:tvdb_id].present?
      @program = Program.find_or_create_by_tvdb_id( params[:tvdb_id] )
      if @program.persisted?
        current_user.program_preferences.create( :program_id => @program.id, :search_term_type_id => params[:search_term_type_id] )
        flash[:notice] = 'Program added'
      else
        flash[:error] = 'Sorry, could not add program'
      end
      respond_to do |format|
        format.html { redirect_to user_programs_path(current_user) }
        format.js { render :text => "document.location.href = '#{user_programs_path(current_user)}'" }
      end
    # from add program modal
    elsif params[:program_preference][:q].present? && params[:program_preference][:search_term_type_id].present?
      @program = Program.search_program(params[:program_preference][:q]).first
      if @program && @program.name.downcase == params[:program_preference][:q].downcase
        if current_user.program_preferences.create( :program_id => @program.id, :search_term_type_id => params[:program_preference][:search_term_type_id] )
          flash[:notice] = 'Program added'
        else
          flash[:error] = 'Could not add program'
        end
        respond_to do |format|
          format.html { redirect_to user_programs_path(current_user) }
          format.js { render :text => "document.location.href = '#{user_programs_path(current_user)}'" }
        end
      else
        suggest
      end
    else
      suggest
    end
  end

  def suggest
    logger.debug "Needs a suggestion..."
    respond_to do |format|
      format.html { render :text => 'no no no' }
      format.js   { render :text => "document.location.href = '#{suggest_programs_path({:q => params[:program_preference][:q]})}';"}
    end
  end

end