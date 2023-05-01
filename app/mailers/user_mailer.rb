class UserMailer < ApplicationMailer
    default from: 'valetbike223@gmail.com'
    
    # finds the user and authentication code from previous controller, creates email to send to user with the code.
    def verification_email
        @user = params[:user]
        @vcode = params[:vcode]
        mail(to: @user.email, subject: 'Verification code')
    end
end