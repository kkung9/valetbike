class StationsController < ApplicationController

  def search
    if params[:reverse].blank? || params[:reverse] == "0"
      @stations = Station.all.order(identifier: :asc)
    else
      @stations = Station.all.order(identifier: :desc)
    end
  end
  
  def index
  end

  def map
    @stations = Station.all
    render('map')
  end

  # def ???
  #   @vacancy = Station.find().capacity - Station.find().bikes.count
  # end

  def station_view
    @station = Station.find(params[:id])
  end

  # private
  # def station_params
    # params.require(:station).permit(:name, :address, :identifier)
    # end
    # ^ for all controllers
    # create & edit & update reference station_params 

  
end
