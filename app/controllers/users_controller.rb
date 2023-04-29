class UsersController < ApplicationController
  def profile
    @user = User.find_by(email: session[:email])
    @rentals = Rental.where(user_id: @user.id)
    render('profile')
  end

  def profile_purchases
    @user = User.find_by(email: session[:email])
    @rentals = Rental.where(user_id: @user.id).order(start_time: :desc)
  end

  def create
    @user = User.new
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.email = params[:email]

    @existing = User.find_by(email: @user.email)
    if @existing.present?
      redirect_to create_account_path
      flash[:error] = "A user account with this email already exists."
    else 
      @user.save
      session[:email] = params[:email]
      session[:vcode] = 4.times.map{rand(10)}.join
      session[:new] = true
      UserMailer.with(user: @user, vcode: session[:vcode]).verification_email.deliver_later

      redirect_to login_verification_path
    end
  end

  def delete
    @user = User.find_by(id: params[:id])
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.update(email: "deleted_user@deleted")
    session.delete(:email)
    redirect_to index_path
  end

  def sub_scess
    @user = User.find_by(email: session[:email])
    @subscriptions = Stripe::Subscription.list({customer: @user.stripe_id})
    @user.sub_id = @subscriptions.first().id
    @user.save
  end

  def subscriptions
  end

  def subscribe
    if !session[:email]
      cookies[:subscribe] = true
      redirect_to '/user_login'
    else
      @user = User.find_by(email: session[:email])

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

  def unsubscribe
    Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

    @user = User.find_by(email: session[:email])
    Stripe::Subscription.cancel(@user.sub_id)
    @user.update(sub_id: nil)
    redirect_to "/profile"
    flash[:alert] = "You have successfully cancelled your subscription."
  end

end
