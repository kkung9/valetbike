class UserMailer < ApplicationMailer
    default from: 'valetbike223@gmail.com'
    
    def verification_email
        @user = params[:user]
        @url = ''
        mail(to: @user.email, subject: 'Verification code')

        puts "Success!"
    end
end
