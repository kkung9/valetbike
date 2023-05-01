class RentalsController < ApplicationController

  # pass station that the user selected before displaying docks to choose a bike
  def rental
    if cookies[:current_station] # if user needs to login before continuing rental process
      @station = Station.find_by(identifier: cookies[:current_station])
      cookies.delete(:current_station)
    else # if user was already logged in
      @station = Station.find_by(identifier: params[:identifier])
    end
  end

  # pass station and bike info before allowing user to choose time
  def purchase_confirm
    # find and save station and bike
    @station = Station.find_by(identifier: params[:station_identifier])
    cookies[:station] = @station.name
    @bike = Bike.find_by(identifier: params[:bike_identifier])
    cookies[:bike] = @bike.identifier
    if session[:email] # if user is logged in 
      @user = User.find_by(email: session[:email])
    elsif session[:guest] # if ride is by a guest
      @user = Guest.find_by(last_name: session[:guest])
    end
    # doesn't allow user to have more than 4 bikes at a time
    if @user.bikes.count  >= 4
      if session[:email] || !!session[:guest]
        redirect_to rental_path(@station.identifier)
        flash[:alert] = "You cannot rent more than four bikes at a time. Please return a bike before proceeding."
      end
    end
  end

  # start a rental
  def create
    @bike = Bike.find_by(identifier: params[:bike_identifier])
    @station = Station.find_by(identifier: params[:station_identifier])
    # create rental object in database
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
    @bike.dock.undock # unassociate bike from its previous dock
    @rental.save
    redirect_to current_path
  end

  # redirect to Stripe to pay for ride
  def pay
    Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

    # find user or guest
    if !!session[:email]
      @user = User.find_by(email: session[:email])
    elsif !!session[:guest]
      @user = Guest.find_by(last_name: session[:guest])
    end

    # create user in Stripe
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
        price: 'price_1N0aHtDRwtZV86UmuNxcpLPe', # $0.90 per 10 mins
        quantity: (params[:duration].to_i)/10, # number of 10 minute periods user wants to ride for
      }],
      allow_promotion_codes: true,
      mode: 'payment',
      success_url: "http://localhost:3000/rentals/success/" + params[:duration],
      cancel_url: "http://localhost:3000/rentals/cancel",
    })
    redirect_to @session.url, status: 303, allow_other_host: true
  end

  # pass information about user to show user's rentals in progress
  def current_ride
    if !!session[:email] # if user is logged in 
      @user = User.find_by(email: session[:email])
    elsif !!session[:guest] # if ride is by a guest
      @user = Guest.find_by(last_name: session[:guest])
    end
      @rentals = Rental.where(user: @user, end_station: nil).order(predicted_end_time: :asc) # list of the user's rentals in progress
  end

  # pass information about the rental that is going to be ended
  def lock
    @rental = Rental.find(params[:id])
    @station_options = Station.all.map{ |u| [ u.name, u.identifier ] } # list of available stations
  end

  # pass rental information for the rental being ended
  def receipt
    @rental = Rental.find(params[:id])
  end  

  # return a bike
  def return
    Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

    @rental = Rental.find(params[:id]) # find rental that is being ended

    @s = Station.find_by(identifier: params[:station_code]) # station user wants to return bike to
    if @s.present? # station must be valid
      @dcode = params[:station_code]+params[:dock_code]
      @d = Dock.find_by(identifier: @dcode)

      if @d.present? # dock must be valid
        if @d.bike.present? # dock must not already have a bug in it
          redirect_to lock_path(@rental.id)
          flash[:error] = "Dock already has a bike in it."
        else
          @rental.end_station = @s.identifier
          @rental.actual_end_time = Time.current
          @rental.save # update rental
          @d.redock(@rental.bike) # associate bike with its new dock
          @d.save

          # if guest returned their last bike, end guest session
          if !!session[:guest] 
            @guest = Guest.find_by(last_name: session[:guest])
            @all_rentals = Rental.where(user: @guest, end_station: nil)
            if @all_rentals.count == 0
              session.delete(:guest)
            end
          end

          # find user or guest
          if !!session[:email]
            @user = User.find_by(email: session[:email])
          elsif !!session[:guest]
            @user = Guest.find_by(last_name: session[:guest])
          end

          # charge user if bike was kept over time
          if @rental.actual_end_time > @rental.predicted_end_time && !@user.sub_id
            @session = Stripe::Checkout::Session.create({
            customer: @user.stripe_id,
            payment_method_types: ['card'],
            line_items: [{
              price: 'price_1N189uDRwtZV86UmrgwQB7E3', # overtime price: $0.50 per min
              quantity: ((@rental.actual_end_time - @rental.predicted_end_time).to_i)/60,
            }], # number of minutes of overtime
            allow_promotion_codes: true,
            mode: 'payment',
            success_url: "http://localhost:3000/receipt/" + @rental.id.to_s,
            cancel_url: "http://localhost:3000/rentals/cancel",
          })
          redirect_to @session.url, status: 303, allow_other_host: true
          flash[:alert] = "We are very disappointed in you for returning your bike late. Please don't do it again."
          else
            redirect_to receipt_path(@rental.id) # redirect to receipt if not overtime
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

  # used to bypass payment for subscribed users
  def member_ride
    redirect_to success_path(params[:duration])
  end

  # pass rental so user can select how much time to extend for
  def extend
    @rental = Rental.find_by(id: params[:id])
  end

  # extend time of ride
  def extend_time
    # find rental and user
    @rental = Rental.find_by(id: params[:id])
    @user = User.find_by(email: session[:email])

    # begin/rescue block to check for time input less than 1 minute
    begin
      #allow subscribed users to bypass payment
      if @user && @user.sub_id
        @rental.update(predicted_end_time: @rental.predicted_end_time + params[:duration].to_i.minutes)
        redirect_to current_path
      elsif !!session[:guest]
          @user = Guest.find_by(last_name: session[:guest])
      end

      Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

      @session = Stripe::Checkout::Session.create({
        customer: @id,
        payment_method_types: ['card'],
        line_items: [{
          price: 'price_1N0aHtDRwtZV86UmuNxcpLPe', # $0.90 per 10 mins
          quantity: (params[:duration].to_i)/10, # number of 10 minute periods user wants to add
        }],
        allow_promotion_codes: true,
        mode: 'payment',
        success_url: "http://localhost:3000/current_ride",
        cancel_url: "http://localhost:3000/rentals/cancel",
      })
      @rental.update(predicted_end_time: @rental.predicted_end_time + params[:duration].to_i.minutes) # increase predicted end time
      redirect_to @session.url, status: 303, allow_other_host: true
    rescue Stripe::InvalidRequestError => invalid
      redirect_to extend_path
      flash[:error] = "Please input a time greater than 0."
    end

  end

end