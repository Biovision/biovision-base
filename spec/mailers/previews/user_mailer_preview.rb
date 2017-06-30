# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def login_attempt
    UserMailer.login_attempt(User.last)
  end
end
