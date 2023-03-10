class StationsController < ApplicationController
  
  def index
    if params[:reverse].blank? || params[:reverse] == "0"
      @stations = Station.all.order(identifier: :asc)
    else
      @stations = Station.all.order(identifier: :desc)
    end
  end
  
end
