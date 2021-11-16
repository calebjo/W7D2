class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    helper_method :current_user, :logged_in?

    def login!(user) # reset user's session token and cookie
        session[:session_token] = user.reset_session_token!
    end

    def logout!
        current_user.reset_session_token! if logged_in?
        session[:session_token] = nil
        @current_user = nil
    end

    # BEFORE ACTION METHODS ------------------------------

    def require_user!
        redirect_to new_session_url if current_user.nil?
    end

    def require_no_user!
        redirect_to users_url if current_user
    end

    # HELPER METHODS -------------------------------------

    def current_user # returns current user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in? # returns boolean indicating whether someone is signed in
        !!current_user
    end
end
