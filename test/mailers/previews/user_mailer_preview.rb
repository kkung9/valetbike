# Preview all emails at http://127.0.0.1:9292//rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def verification_email
        UserMailer.with(user: User.first).verification_email
    end
end
