class Admin::UsersController < AdminAreaController
  before_filter :get_user, :except => [:index, :new, :create]

  def index
    @users = User.all
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to([:admin, @user], :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @user.attributes = params[:user]
      @user.email      = params[:user][:email] if params[:user][:email]
      @user.trusted    = params[:user][:trusted]
      @user.admin      = params[:user][:admin]
      if @user.save
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
  
  def get_user
    @user = User.find_by_login(params[:id])
    raise ActiveRecord::RecordNotFound unless @user
  end
end
