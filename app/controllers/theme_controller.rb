# app/controllers/theme_controller.rb
class ThemeController < ApplicationController
  
  # checks cookies and maintains display theme (light or dark mode) based on system default or user selection.
  def update
    cookies[:theme] = params[:theme]
    redirect_to(request.referrer || root_path)
  end
  end