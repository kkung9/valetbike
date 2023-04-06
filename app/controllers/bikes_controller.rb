class BikesController < ApplicationController
  def index
    if params[:reverse].blank? || params[:reverse] == "0"
      @bikes = Bike.all.order(identifier: :asc)
    else
      @bikes = Bike.all.order(identifier: :desc)

      @current_user = Bike.find(3).rental.where(is_complete: false).first.user  
      # replace 3 with params for applicability
      # @current_user_id = @current_user.first.user_id

    end
  end

end