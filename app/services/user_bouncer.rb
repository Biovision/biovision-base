class UserBouncer
  # @param [User] user
  def initialize(user)
    @user = user
  end

  # @param [String] password
  # @param [Hash] tracking
  def let_user_in?(password, tracking)
    return false unless @user&.allow_login?
    @user.authenticate(password)
  end
end
