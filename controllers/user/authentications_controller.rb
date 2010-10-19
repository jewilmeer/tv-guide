class User::AuthenticationsController < UserAreaController
  def destroy
    if current_user.authentications.delete( Authentication.find(params[:id]) )
      redirect_to :back, :notice => 'External service deleted'
    else
      redirect_to :back, :error => 'Deletion failed'
    end    
  end
end