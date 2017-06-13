class CodeManager::Recovery < CodeManager
  # @return [CodeType]
  def self.code_type
    @code_type ||= CodeType.find_by!(slug: 'recovery')
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

  # @param [Hash] new_parameters
  def activate(new_parameters)
    return false if @code.quantity < 1 || new_parameters[:password].blank?
    new_parameters[:email_confirmed] = true if @code.payload == @code.user.email
    user_updated = @code.user.update(new_parameters)
    if user_updated
      @code.decrement!(:quantity)
    end
    user_updated
  end
end