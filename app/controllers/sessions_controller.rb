class SessionsController < ApplicationController
  def create
    session[:email] = params[:email]
    @existing = User.find_by(email: session[:email])
    if @existing.present?

      # HARDCODED AS "1111" FOR NOW - Mercer + Yurika
      UserMailer.with(user: @existing).verification_email.deliver_later

      redirect_to login_verification_path
    else
      redirect_to create_session_path
      flash[:error] = "You do not yet have an account with the email provided. Please create a new account."
    end
  end

  def login
    @code = params[:code]

    if @code == "1111"
      if cookies[:current_station]
        s = cookies[:current_station]
        cookies.delete(:current_station)
        redirect_to rental_path(s)
      else
        redirect_to profile_path
      end
    else
      redirect_to login_verification_path
      flash[:error] = "Your code was incorrect. Please try again."
    end

  end

  def logout
    session.delete(:email)
    redirect_to index_path
  end
end
