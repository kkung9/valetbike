# app/controllers/theme_controller.rb
class ThemeController < ApplicationController
  def update
    cookies[:theme] = params[:theme]
    redirect_to(request.referrer || root_path)
  end
  end