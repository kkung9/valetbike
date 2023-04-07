class RentalsController < ApplicationController

    def rental
        @station = Station.find(params[:id])
        render('rental')
      end

    def receipt
      @rental = Rental.find(params[:id])
    end

    def purchase_confirm
      @station = Station.find(params[:station_id])
      @bike = Bike.find(params[:bike_id])
      @rental = Rental.new
    end

    def current_ride
      @rental = Rental.find(params[:id])
    end


end