class UsersController < ApplicationController
  def profile
    @user = User.find_by(email: session[:email])
    @rentals = Rental.where(user_id: @user.id)
    render('profile')
  end

  def profile_purchases
    @user = User.find_by(email: session[:email])
    @rentals = Rental.where(user_id: @user.id).order(start_time: :desc)
  end

  def create
    @user = User.new
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.email = params[:email]

    @existing = User.find_by(email: @user.email)
    if @existing.present?
      redirect_to create_account_path
      flash[:error] = "A user account with this email already exists."
    else 
      @user.save
      session[:email] = params[:email]
      session[:vcode] = 4.times.map{rand(10)}.join
      session[:new] = true
      UserMailer.with(user: @user, vcode: session[:vcode]).verification_email.deliver_later

      redirect_to login_verification_path
    end
  end
  
end
