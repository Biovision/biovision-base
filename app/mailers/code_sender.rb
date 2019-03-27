# frozen_string_literal: true

# Mailer for sending codes to users
class CodeSender < ApplicationMailer
  # Email confirmation code
  #
  # @param [Integer] code_id
  def email(code_id)
    @code = Code.find_by(id: code_id)

    return if @code.nil? || @code.user.email.blank?

    mail to: @code.user.email
  end

  # Password reset code
  #
  # @param [Integer] code_id
  def password(code_id)
    @code = Code.find_by(id: code_id)

    return if @code.nil? || @code.user.email.blank?

    mail to: @code.user.email
  end
end
