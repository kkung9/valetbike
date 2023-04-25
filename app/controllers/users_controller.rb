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
    puts params[:id]
    @user = User.find_by(id: params[:id])
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    session.delete(:email)
    redirect_to index_path
  end

  def sub_scess
    @user = User.find_by(email: session[:email])
    @user.sub_id
  end

  def sub_cookie
    
  end

  def subscriptions
  end

  def subscribe
    @user = User.find_by(email: session[:email])

    Stripe.api_key = "sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"

    if !!@user.stripe_id
      @id = Stripe::Customer.retrieve(@user.stripe_id)
    else
      @stripe_user = Stripe::Customer.create({
        metadata: {user_id: @user.id}
      })
      @user.stripe_id = @stripe_user["id"]
      @user.save
    end

    puts "lllll"
    puts params[:price]

    @session = Stripe::Checkout::Session.create({
      customer: @id,
      payment_method_types: ['card'],
      line_items: [{
        price: params[:price],
        quantity: 1,
      }],
      allow_promotion_codes: true,
      mode: 'subscription',
      success_url: "http://localhost:3000/sub_scess" + @session,
      cancel_url: "http://localhost:3000/index",
    })
  
    redirect_to @session.url, status: 303, allow_other_host: true
  end

  def unsubscribe
    @user = User.find_by(email: session[:email])
    Stripe::Subscription.cancel(@user.sub_id)
  end

end
