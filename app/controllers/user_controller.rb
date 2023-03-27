class UserController < ApplicationController
  def profile
    render('profile')
    @user = User.find_by(firstName: "Stephen")
  end
end
