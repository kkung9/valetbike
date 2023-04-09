class RentalsController < ApplicationController

    def rental
      if cookies[:current_station]
        @station = Station.find_by(identifier: cookies[:current_station])
        cookies.delete(:current_station)
      else
        @station = Station.find_by(identifier: params[:identifier])
      end
      render('rental')
    end

    def receipt
      @rental = Rental.find(params[:id])
    end

    def purchase_confirm
      @station = Station.find_by(identifier: params[:station_identifier])
      @bike = Bike.find_by(identifier: params[:bike_identifier])
    end

    def create
      @bike = Bike.find_by(identifier: params[:bike_identifier])
      @station = Station.find_by(identifier: params[:station_identifier])
      @rental = Rental.new
      @rental.user_id = User.find_by(email: session[:email]).id
      @rental.bike_id = @bike.id
      @rental.start_station = @station.id
      @rental.start_time = Time.current
      @rental.predicted_end_time = Time.current + params[:duration].to_i.minutes
      @bike.dock.undock
      @rental.save
      redirect_to current_path
    end

    def current_ride
      @user = User.find_by(email: session[:email])
      @rentals = Rental.where(user: @user, end_station: nil).order(predicted_end_time: :asc)
    end

    def lock
      @rental = Rental.find(params[:id])
    end

    def update
      @rental = Rental.find(params[:id])

      @s = Station.find_by(identifier: params[:station_code])
      if @s.present?
        @dcode = params[:station_code]+params[:dock_code]
        @d = Dock.find_by(identifier: @dcode)
        if @d.present?
          if @d.bike.present?
            redirect_to lock_path(@rental.id)
            flash[:error] = "Dock already has a bike in it."
          else
            @rental.end_station = @s.id
            @rental.actual_end_time = Time.current
            @rental.save
            @d.redock(@rental.bike)
            redirect_to receipt_path(@rental.id)
          end
        else
          redirect_to lock_path(@rental.id)
          flash[:error] = "Invalid dock code."
        end
      else 
        redirect_to lock_path(@rental.id)
        flash[:error] = "Invalid station code."
      end

      
    end


end