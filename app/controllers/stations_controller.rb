class StationsController < ApplicationController

  # searches the databse and returns all stations with names similar to those entered by the user in the search bar.
  def search
      if !params[:name].blank?
        @stations = Station.all.where('name LIKE ?', "%#{params[:name]}%")
      else
        @stations = Station.all
      end
    end
  
  def index
  end

  # displays all stations on the map interface.
  def map
    @stations = Station.all
    render('map')
  end

  # returns the station that should be displayed in the station view, based on the params entered by the user.
  def station_view
    @station = Station.find_by(identifier: params[:identifier])
  end

  private
  def station_params
    params.require(:station).permit(:name, :address, :identifier, :photo)
  end
    # ^ for all controllers
    # create & edit & update reference station_params 

  
end
