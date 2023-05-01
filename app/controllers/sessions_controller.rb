class SessionsController < ApplicationController

  # creates a new session object using params from login
  def create
    session[:email] = params[:email]
    @existing = User.find_by(email: session[:email])

    # checks if the user is already in the database. 
    if @existing.present?
      # generates a random 4-digit authentication code and sends user an email with the code
      session[:vcode] = 4.times.map{rand(10)}.join
      UserMailer.with(user: @existing, vcode: session[:vcode]).verification_email.deliver_later
      redirect_to login_verification_path
    # checks if input email is blank, then flashes error to correct the issue
    elsif params[:email].blank?
      redirect_to user_login_path
      flash[:error] = "Please input a valid email address."
    # if user not present in databse and input field not blank, flashes error telling user to create a new account
    else
      redirect_to user_login_path
      flash[:error] = "You do not yet have an account with the email provided. Please create a new account."
    end
  end

  # checks authentication code provided by user against the code held in the current session
  def login
    @code = params[:code]
    if @code == session[:vcode]
      # checks if user was already in the process of renting a bike, redirects appropriately
      if cookies[:current_station]
        s = cookies[:current_station]
        cookies.delete(:current_station)
        session[:verified] = true
        redirect_to rental_path(s)
      # checks if user was in the process of creating a subscription, redirects appropriately
      elsif cookies[:subscribe]
        cookies.delete(:subscribe)
        redirect_to subscriptions_path
        flash[:error] = "You successfully logged in. You may now subscribe."
      else
        # sets the user's login status as verified and redirects user to the appropriate path (profile or account confirmation) 
        # depending on whether the user is in the process of creating a new account or logging in
        if session[:new] == true
          session[:verified] = true
          redirect_to account_confirmation_path
        else
          session[:verified] = true
          redirect_to profile_path
        end
      end
    # reloads page and flashes an error if the inputted authentication code is incorrect
    else
      redirect_to login_verification_path
      flash[:error] = "Your code was incorrect. Please try again."
    end

  end

  # ends all login sessions and sends the user to the homepage
  def logout
    session.delete(:email)
    session.delete(:vcode)
    session.delete(:verified)
    session.delete(:new)
    redirect_to index_path
  end
end
