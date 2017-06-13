class CodeManager::Invitation < CodeManager
  # @return [CodeType]
  def self.code_type
    @code_type ||= CodeType.find_by!(slug: 'invitation')
  end

  # @param [User] user
  def self.code_for_user(user)
    code = code_type.codes.active.owned_by(user).first
    if code.nil?
      code = code_type.codes.create(user: user)
    end
    code
  end

  def code_is_valid?
    return false if @code.nil?
    @code.active? && @code.code_type == self.code_type
  end

  # @param [User] invitee
  def activate(invitee)
    return if invitee.nil? || @code.quantity < 1
    @code.decrement!(:quantity)
    invitee.update(inviter_id: @code.user_id)
  end
end