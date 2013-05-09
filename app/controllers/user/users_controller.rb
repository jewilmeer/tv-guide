class User::UsersController < UserAreaController
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.create params[:user]
    respond_with @user, location: station_path(@user.stations.first)
  end

  def edit
    @user = current_user
  end

  def update
    session[:return_to] = nil

    current_user.update_attributes!(params[:user])
    flash[:notice] = 'Account updated'
    redirect_to edit_user_path(current_user)
  rescue StandardError => e
    current_user.reset_login! #if we don't do this it will break to urls
    flash[:error] = 'Update failed'
    render :edit
  end
end