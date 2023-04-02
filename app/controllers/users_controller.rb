class UsersController < ApplicationController
  def profile
    @user = User.find_by(first_name: "Stephen")
    render('profile')
  end
  
end
