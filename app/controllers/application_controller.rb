class ApplicationController < ActionController::Base

  layout 'application'

  # turn dark mode on
  def moon
    cookies[:moon] = {
      value: 'dark mode on'
    }
    redirect_to moon_path
  end

  # turn light mode on
  def sun
    cookies.delete(:moon)
    redirect_to sun_path
  end
end
