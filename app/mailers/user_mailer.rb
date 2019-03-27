# frozen_string_literal: true

# Mailer for user-related things
class UserMailer < ApplicationMailer
  # @param [Integer] user_id
  def login_attempt(user_id)
    @user = User.find_by(id: user_id)

    return if @user.nil? || @user.email.blank?

    mail to: @user.email
  end
end
