class User::ProgramPreferencesController < UserAreaController
  
  def index
    @program_preferences = current_user.program_preferences.all#.includes(:program)#.included(:program)
    @search_term_types   = SearchTermType
  end
end