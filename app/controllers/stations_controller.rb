class StationsController < ApplicationController
  
  def list
    if params[:reverse].blank? || params[:reverse] == "0"
      @stations = Station.all.order(identifier: :asc)
    else
      @stations = Station.all.order(identifier: :desc)
    end
  end

  def search
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
