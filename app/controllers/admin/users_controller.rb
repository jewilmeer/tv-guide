class Admin::UsersController < AdminAreaController
  respond_to :html
  before_filter :get_user, :except => [:index, :new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def update
    respond_to do |format|
      if @user.update_attributes user_params
        flash[:notice] = 'Update successful!'
        format.html { redirect_to(:back, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        @user.reset_login!
        flash[:error] = 'Update failed!'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def get_user
    @user = User.friendly.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :login, :trusted, :admin)
  end
end
