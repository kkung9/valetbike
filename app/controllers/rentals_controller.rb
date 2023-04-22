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
      if !!session[:verified]
        @rental.user_id = User.find_by(email: session[:email]).id
      elsif !!session[:guest]
        @rental.user_id = Guest.find_by(last_name: session[:guest]).id
      end
      @rental.bike_id = @bike.id
      @rental.start_station = @station.identifier
      @rental.start_time = Time.current
      @rental.predicted_end_time = @rental.start_time + params[:duration].to_i.minutes
      @bike.dock.undock
      @rental.save
      redirect_to current_path
    end

    def current_ride
      if !!session[:email]
        @user = User.find_by(email: session[:email])
      elsif !!session[:guest]
        @user = Guest.find_by(last_name: session[:guest])
      end
        @rentals = Rental.where(user: @user, end_station: nil).order(predicted_end_time: :asc)
    end

    def lock
      @rental = Rental.find(params[:id])
      @station_options = Station.all.map{ |u| [ u.name, u.identifier ] }
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
            @rental.end_station = @s.identifier
            @rental.actual_end_time = Time.current
            @rental.save
            @d.redock(@rental.bike)
            @d.save
            if !!session[:guest]
              @guest = Guest.find_by(last_name: session[:guest])
              @all_rentals = Rental.where(user: @guest, end_station: nil)
              if @all_rentals.count == 0
                session.delete(:guest)
              end
            end
            puts "bbbb"
            puts @d.bike.id
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