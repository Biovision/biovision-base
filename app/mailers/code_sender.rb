class CodeSender < ApplicationMailer
  # @param [Integer] code_id
  def email(code_id)
    @code = Code.find_by(id: code_id)

    mail to: @code.user.email unless @code.nil?
  end

  # @param [Integer] code_id
  def password(code_id)
    @code = Code.find_by(id: code_id)

    mail to: @code.user.email unless @code.nil?
  end
end
