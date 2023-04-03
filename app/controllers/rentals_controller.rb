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
    end

    def create
      @bike = Bike.find(params[:bike_id])
      @station = Station.find(params[:station_id])
      @rental = Rental.new
      @rental.user_id = User.find_by(first_name: "Stephen").id
      @rental.bike_id = @bike.id
      @rental.start_station = @station.id
      @rental.start_time = Time.current
      @rental.predicted_end_time = Time.current + params[:duration].to_i.minutes
      @rental.save
      redirect_to current_path(@rental.id)
    end

    def current_ride
      @rental = Rental.find(params[:id])
    end

    def lock
      @rental = Rental.find(params[:id])
    end

    def update
      @rental = Rental.find(params[:id])
      @rental.end_station = Station.find_by(identifier: params[:station_code]).id
      @rental.actual_end_time = Time.current
      @rental.save
      redirect_to receipt_path(@rental.id)
    end


end