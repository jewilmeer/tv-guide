class Admin::UsersController < AdminAreaController
  helper_method :sort_column, :sort_direction
  before_filter :get_user, :except => [:index, :new, :create]

  def index
    @users = User.order(sort_column + ' ' + sort_direction).paginate :per_page => 30, :page => params[:page]
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
  
  protected
  def get_user
    @user = User.find_by_login(params[:id])
    raise ActiveRecord::RecordNotFound unless @user
  end
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "login"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
