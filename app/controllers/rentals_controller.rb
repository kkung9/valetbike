class RentalsController < ApplicationController

    def rental
      if cookies[:current_station]
        @station = Station.find_by(identifier: cookies[:current_station])
        cookies.delete(:current_station)
      else
        @station = Station.find_by(identifier: params[:identifier])
      end
    end

    def receipt
      @rental = Rental.find(params[:id])
    end

    def purchase_confirm
      @station = Station.find_by(identifier: params[:station_identifier])
      cookies[:station] = @station.name
      @bike = Bike.find_by(identifier: params[:bike_identifier])
      cookies[:bike] = @bike.identifier
      if session[:email]
        @user = User.find_by(email: session[:email])
      elsif session[:guest]
        @user = Guest.find_by(last_name: session[:guest])
      end
      puts "aaaa"
      puts session[:guest]
      if @user.bikes.count  >= 4
        if session[:email] || !!session[:guest]
          puts 'bbb'
          puts 'Flash triggered!'
          redirect_to rental_path(@station.identifier)
          flash[:alert] = "You cannot rent more than four bikes at a time. Please return a bike before proceeding."
        end
      end
      
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

    def return
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

            if !!session[:email]
              @user = User.find_by(email: session[:email])
            elsif !!session[:guest]
              @user = Guest.find_by(last_name: session[:guest])
            end

            if @rental.actual_end_time > @rental.predicted_end_time && !@user.sub_id
              
              @session = Stripe::Checkout::Session.create({
              customer: @user.stripe_id,
              payment_method_types: ['card'],
              line_items: [{
                price: 'price_1N189uDRwtZV86UmrgwQB7E3',
                quantity: ((@rental.actual_end_time - @rental.predicted_end_time).to_i)/60,
              }],
              allow_promotion_codes: true,
              mode: 'payment',
              success_url: "http://https://valetbike-rr.herokuapp.com/receipt/" + @rental.id.to_s,
              cancel_url: "http://https://valetbike-rr.herokuapp.com/rentals/cancel",
            })
            redirect_to @session.url, status: 303, allow_other_host: true
            flash[:alert] = "We are very disappointed in you for returning your bike late. Please don't do it again."
            else
              redirect_to receipt_path(@rental.id)
            end

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

    def pay
      if !!session[:email]
        @user = User.find_by(email: session[:email])
      elsif !!session[:guest]
        @user = Guest.find_by(last_name: session[:guest])
      end

      Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

      if !!@user && !!@user.stripe_id
        @id = Stripe::Customer.retrieve(@user.stripe_id).id
      else
        @stripe_user = Stripe::Customer.create({
          name: @user.first_name + " " + @user.last_name,
          email: @user.email,
          metadata: {user_id: @user.id}
        })
        @user.stripe_id = @stripe_user["id"]
        @user.save
        @id = @user.stripe_id
      end

      @session = Stripe::Checkout::Session.create({
        customer: @id,
        payment_method_types: ['card'],
        line_items: [{
          price: 'price_1N0aHtDRwtZV86UmuNxcpLPe',
          quantity: (params[:duration].to_i)/10,
        }],
        allow_promotion_codes: true,
        mode: 'payment',
        success_url: "http://https://valetbike-rr.herokuapp.com/rentals/success/" + params[:duration],
        cancel_url: "http://https://valetbike-rr.herokuapp.com/rentals/cancel",
      })
      redirect_to @session.url, status: 303, allow_other_host: true
    end

    def member_ride
      redirect_to success_path(params[:duration])
    end

    def extend
      @rental = Rental.find_by(id: params[:id])
    end

    def extend_time
      @rental = Rental.find_by(id: params[:id])
      @user = User.find_by(email: session[:email])
      if @user && @user.sub_id
        @rental.update(predicted_end_time: @rental.predicted_end_time + params[:duration].to_i.minutes)
        redirect_to current_path
      else
        if !!session[:guest]
          @user = Guest.find_by(last_name: session[:guest])
        end

        Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

        if !!@user.stripe_id
          @id = Stripe::Customer.retrieve(@user.stripe_id).id
        else
          @stripe_user = Stripe::Customer.create({
            name: @user.first_name + " " + @user.last_name,
            email: @user.email,
            metadata: {user_id: @user.id}
          })
          @user.stripe_id = @stripe_user["id"]
          @user.save
          @id = @user.stripe_id
        end

        @session = Stripe::Checkout::Session.create({
          customer: @id,
          payment_method_types: ['card'],
          line_items: [{
            price: 'price_1N0aHtDRwtZV86UmuNxcpLPe',
            quantity: (params[:duration].to_i)/10,
          }],
          allow_promotion_codes: true,
          mode: 'payment',
          success_url: "http://https://valetbike-rr.herokuapp.com/current_ride",
          cancel_url: "http://https://valetbike-rr.herokuapp.com/rentals/cancel",
        })
        @rental.update(predicted_end_time: @rental.predicted_end_time + params[:duration].to_i.minutes)
        redirect_to @session.url, status: 303, allow_other_host: true
      
      end
    end

end