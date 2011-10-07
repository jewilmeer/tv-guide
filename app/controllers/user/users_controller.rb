class User::UsersController < UserAreaController
  skip_before_filter :get_user, :only => [:new, :create]
  before_filter :require_ownership, :only => [:edit, :update]
  def show
    @user = User.find_by_login(params[:id], :include => :programs)
  end

  def new
    @user = User.new
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth]) 
    end
  end
  
  def create
    @user = User.new(params[:user])
    @user.apply_omniauth(session[:omniauth]) if session[:omniauth].present?
    if @user.save
      session[:omniauth] = nil
      redirect_to([@user, :programs], :notice => 'User was successfully created.')
    else
      render :new
    end
  end

  def edit
    
  end
  
  def update
    session[:return_to] = nil
    
    current_user.update_attributes!(params[:user])
    flash[:notice] = 'Account updated'
    redirect_to edit_user_path(current_user)
  rescue StandardError => e
    logger.debug e
    current_user.reset_login! #if we don't do this it will break to urls
    flash[:error] = 'Update failed'
    render :edit
  end

  def require_ownership
    render :status => 401, :text => 'not allowed' unless current_user == @user
    logger.debug "current_user: #{current_user.inspect}"
    logger.debug "user: #{@user.inspect}"
    
  end
end