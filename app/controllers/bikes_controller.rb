class BikesController < ApplicationController
  def index
    # The codes below are for admins
    # @current_user will return the cureent user of the bike.
    # @current_user = Bike.find(0).rental.where(is_complete: false).first.user
    # @current_user_id = @current_user.first.user_id
    if params[:reverse].blank? || params[:reverse] == "0"
      @bikes = Bike.all.order(identifier: :asc)
    else
      @bikes = Bike.all.order(identifier: :desc) 

      @current_user = Bike.all.where(identifier: 1000).first.rental.where(is_complete: false).first.user.firstName 
      puts(@current_user)

      @past_users = Bike.all.where(identifier: 1000).first.user
      # replace 3 with params for applicability
      # @current_user_id = @current_user.first.user_id

    end
  end

end