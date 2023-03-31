class StationsController < ApplicationController

  def search
    if params[:reverse].blank? || params[:reverse] == "0"
      @stations = Station.all.order(identifier: :asc)
    else
      @stations = Station.all.order(identifier: :desc)
    end
    render('search')
  end
  
  def index
  end

  def map
    render('map')
  end

  def station_view
    @station = Station.find_by(identifier: "21")
    @hello = "hello"
  end

  # private
  # def station_params
    # params.require(:station).permit(:name, :address, :identifier)
    # end
    # ^ for all controllers
    # create & edit & update reference station_params 
  
end
