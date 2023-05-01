class UsersController < ApplicationController

  # finds and returns the logged-in user and their past and current rentals to display on the profile page
  def profile
    @user = User.find_by(email: session[:email])
    @rentals = Rental.where(user_id: @user.id)
    render('profile')
  end

  # # finds and returns the logged-in user and their past and current rentals to display on the past purchases page
  def profile_purchases
    @user = User.find_by(email: session[:email])
    @rentals = Rental.where(user_id: @user.id).order(start_time: :desc)
  end

  # creates a new user object and saves to the database
  def create
    @user = User.new
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.email = params[:email]

    @existing = User.find_by(email: @user.email)

    # checks if the user already exists in the database and flashes an error notifying the user that they already have an account
    if @existing.present?
      redirect_to create_account_path
      flash[:error] = "A user account with this email already exists."
    # creates a random 4-digit authentication code and sends it to the user via email before redirecting to login verification.
    else 
      @user.save
      session[:email] = params[:email]
      session[:vcode] = 4.times.map{rand(10)}.join
      session[:new] = true
      UserMailer.with(user: @user, vcode: session[:vcode]).verification_email.deliver_later

      redirect_to login_verification_path
    end
  end

  # finds the user that is currently logged in as they navigate the delete profile view.
  def delete
    @user = User.find_by(id: params[:id])
  end

  # finds the user account in the databse, updates the email so that past rental information is saved but the user can no longer
  # log in, then deletes the current session and sends the user back to the home page.
  def destroy
    @user = User.find_by(id: params[:id])
    @user.update(email: "deleted_user@deleted")
    session.delete(:email)
    redirect_to index_path
  end

  # finds and updates the user account with the user's new Stripe subscription id following a successful subscription payment. 
  def sub_scess
    @user = User.find_by(email: session[:email])
    @subscriptions = Stripe::Subscription.list({customer: @user.stripe_id})
    @user.sub_id = @subscriptions.first().id
    @user.save
  end

  def subscriptions
  end

  # creates a new subscription for the user via the Stripe API.
  def subscribe
    # ensures that there is a user currently logged in for the subscription. if not, redirects to the login path.
    if !session[:email]
      cookies[:subscribe] = true
      redirect_to '/user_login'
    else
      @user = User.find_by(email: session[:email])

      # the application's unique Stripe secret API key:
      Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

      # checks if the user exists and has an existing Stripe ID, then retrieves the Stripe ID
      if !!@user && !!@user.stripe_id
        @id = Stripe::Customer.retrieve(@user.stripe_id).id
      # otherwise, creates a new Stripe customer object for the user and stores their unique Stripe ID to access in the future.
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

      # begins a new Stripe checkout session with a subscription Stripe price object based on the 'monthly' or 'annual' selection
      # previously made by the user. redirects to a success page or cancel page depending on whether the payment succeeded.
      @session = Stripe::Checkout::Session.create({
        customer: @id,
        payment_method_types: ['card'],
        line_items: [{
          price: params[:price],
          quantity: 1,
        }],
        allow_promotion_codes: true,
        mode: 'subscription',
        success_url: "http://localhost:3000/subscription_success",
        cancel_url: "http://localhost:3000/index",
      })
      redirect_to @session.url, status: 303, allow_other_host: true
    end
  end

  # cancels the user's subscription via the Stripe API and redirects to the profile page with a flash alert confirmation.
  def unsubscribe
    Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

    @user = User.find_by(email: session[:email])
    Stripe::Subscription.cancel(@user.sub_id)
    @user.update(sub_id: nil)
    redirect_to "/profile"
    flash[:alert] = "You have successfully cancelled your subscription."
  end

end
