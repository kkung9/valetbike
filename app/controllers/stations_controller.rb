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

  # def ???
  #   @vacancy = Station.find().capacity - Station.find().bikes.count
  # end
  
end
