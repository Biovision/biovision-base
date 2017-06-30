class UserMailer < ApplicationMailer
  # @param [Integer] user_id
  def login_attempt(user_id)
    @user = User.find_by(id: user_id)

    mail to: @user.email unless @user&.email.blank?
  end
end
