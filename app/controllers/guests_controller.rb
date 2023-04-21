class GuestsController < ApplicationController
  def create
    @guest = Guest.new
    @guest.first_name = "Guest"
    @guest.last_name = 8.times.map{rand(10)}.join.to_str
    @guest.email = "guest@guest.guest"
    @guest.save
    session[:guest] = @guest.last_name
    @s = cookies[:current_station]
    redirect_to rental_path(@s)
  end
end
