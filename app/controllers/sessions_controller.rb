class SessionsController < ApplicationController
  def create
    session[:email] = params[:email]
    @existing = User.find_by(email: session[:email])
    if @existing.present?

      session[:vcode] = 4.times.map{rand(10)}.join
      UserMailer.with(user: @existing, vcode: session[:vcode]).verification_email.deliver_later

      redirect_to login_verification_path
    else
      redirect_to create_session_path
      flash[:error] = "You do not yet have an account with the email provided. Please create a new account."
    end
  end

  def login
    @code = params[:code]
    if @code == session[:vcode]
      if cookies[:current_station]
        s = cookies[:current_station]
        cookies.delete(:current_station)
        session[:verified] = true
        redirect_to rental_path(s)
      elsif cookies[:subscribe]
        cookies.delete(:subscribe)
        redirect_to subscriptions_path
      else
        if session[:new] == true
          session[:verified] = true
          redirect_to account_confirmation_path
        else
          session[:verified] = true
          redirect_to profile_path
        end
      end
    else
      redirect_to login_verification_path
      flash[:error] = "Your code was incorrect. Please try again."
    end

  end

  def logout
    session.delete(:email)
    session.delete(:vcode)
    session.delete(:verified)
    session.delete(:new)
    redirect_to index_path
  end
end
