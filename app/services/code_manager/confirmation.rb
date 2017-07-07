class CodeManager::Confirmation < CodeManager
  # @return [CodeType]
  def self.code_type
    @code_type ||= CodeType.find_by!(slug: 'confirmation')
  end

  # @param [User] user
  def self.code_for_user(user)
    code = code_type.codes.active.find_by(user: user)
    if code.nil?
      code = code_type.codes.create(user: user, payload: user.email)
    end
    code
  end

  def code_is_valid?
    return false if @code.nil?
    @code.active? && @code.code_type == self.class.code_type
  end

  def activate
    return if @code.quantity < 1
    @code.decrement!(:quantity)
    @code.user.update email_confirmed: true if @code.payload == @code.user.email
  end
end