module ApplicationHelper
    def logged_in?
        !!session[:verified]
    end

    def current_user
        @current_user ||= User.find_by_id(session[:email]) if !!session[:email]
    end
end
