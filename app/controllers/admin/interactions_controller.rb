class Admin::InteractionsController < AdminAreaController
  helper_method :sort_column, :sort_direction
  def index
    @interactions = Interaction.order(sort_column + ' ' + sort_direction)
  end

  protected
  def sort_column
    Interaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end