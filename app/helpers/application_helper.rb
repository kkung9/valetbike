module ApplicationHelper

    # checks if the user has been logged in.
    def logged_in?
        !!session[:verified]
    end

    # finds the user that is currently logged in based on the emails stored in session.
    def current_user
        @current_user ||= User.find_by_id(session[:email]) if !!session[:email]
    end
end
