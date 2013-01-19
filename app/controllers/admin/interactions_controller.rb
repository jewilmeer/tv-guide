class Admin::InteractionsController < AdminAreaController
  def index
    @interactions = Interaction.order('id desc').page params[:page]
  end
end