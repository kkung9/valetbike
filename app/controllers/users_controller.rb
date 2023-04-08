class UsersController < ApplicationController
  def profile
    @user = User.find_by(first_name: "Stephen")
    @rentals = Rental.where(user_id: @user.id)
    render('profile')
  end

  def profile_purchases
    @user = User.find_by(id: 1)
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
      redirect_to account_confirmation_path
    end
  end

  def login
    @temp = User.new
    @temp.email = params[:email]

    @existing = User.find_by(email: @temp.email)
    if @existing.present?
      redirect_to profile_path
    else
      flash[:error] = "You do not yet have an account with the email provided. Please create a new account."
    end
  end
  
end
