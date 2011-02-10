module Sellaband
  module Authentication
    # method to reduce calls
    def default_request_format?
      !( params[:format] && %w(rss xml jpg mp3 json nzb).include?(params[:format]) )
    end
  
    # auth-logic
    protected
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end

      def load_user_using_perishable_token
        @user = User.find_using_perishable_token(params[:id])  
        unless @user  
          flash[:error] =  "We\'re sorry, but we could not locate your account. " +  
          "If you are having issues try copying and pasting the URL " +  
          "from your email into your browser. "
          redirect_to root_url  
        end  
      end

      def is_admin?
        current_user && current_user.admin?
      end

      def require_admin
        unless is_admin?
          store_location
          flash[:error] = 'Accesslevel 5 required'
          redirect_to new_user_session_url
          return false
        end
      end
    
      def require_user
        unless current_user
          store_location
          flash[:warning] = t('authentication.need_login')
          redirect_to new_user_session_url
          return false
        end
      end
 
      def require_no_user
        if current_user
          store_location
          flash[:warning] = 'You need to logout before you can login again'
          return false
        end
      end
    
      def require_trust
        render :file => "public/401.html", :status => 401, :layout => false unless current_user && current_user.trusted?
      end
        
      def store_location
        # session[:return_to] = request.full_path if default_request_format?
      end
    
      def location_stored?
        session[:return_to]
      end
    
      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default || '/')
        session[:return_to] = nil
      end
      
      def logged_in?
        !!current_user
      end
      # Inclusion hook to make #current_user and #logged_in?
      # available as ActionView helper methods.
      def self.included(base)
        base.send :helper_method, :current_user_session, :current_user, :is_admin?, :logged_in?
      end
    end
end