class ApplicationController < ActionController::Base

    layout 'application'
    def moon
        cookies[:moon] = {
          value: 'dark mode on'
        }
        puts("dark mode is on")
        redirect_to moon_path
      end
      def sun
        cookies.delete(:moon)
        puts("light mode is on")
        redirect_to sun_path
      end
end
