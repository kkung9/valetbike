class UsersController < ApplicationController
  def profile
    @user = User.find_by(first_name: "Stephen")
    @rentals = Rental.where(user_id: @user.id)
    render('profile')
  end

  def profile_purchases
    @user = User.find_by(id: params[:id])
    @rentals = Rental.where(user_id: @user.id).order(start_time: :desc)
  end
  
end
