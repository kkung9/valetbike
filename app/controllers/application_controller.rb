class ApplicationController < ActionController::Base

    layout 'application'
    def moon
        cookies[:moon] = {
          value: 'dark mode on'
        }
        redirect_to moon_path
      end
      def sun
        cookies.delete(:moon)
        redirect_to sun_path
      end
end
