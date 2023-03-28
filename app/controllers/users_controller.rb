class UsersController < ApplicationController
  def profile
    @user = User.find_by(firstName: "Stephen")
    render('profile')
  end

  def rental
    @station = Station.find_by(identifier: "21")
    render('rental')
  end
end
