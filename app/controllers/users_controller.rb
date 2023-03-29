class UsersController < ApplicationController
  def profile
    @user = User.find_by(firstName: "Stephen")
    render('profile')
  end
  
end
