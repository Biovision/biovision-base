class UserBouncer
  # @param [User] user
  def initialize(user)
    @user = user
  end

  # @param [String] password
  # @param [Hash] tracking
  def let_user_in?(password, tracking)
    return false unless @user&.allow_login?
    @password = password
    @tracking = tracking
    excessive_attempts? ? log_attempt : try_password
  end

  private

  def excessive_attempts?
    LoginAttempt.owned_by(@user).since(15.minutes.ago) > 4
  end

  def log_attempt
    data = { user: @user, password: @password }
    LoginAttempt.create(data.merge(@tracking))
    false
  end

  def try_password
    @user.authenticate(@password) || count_attempt
  end

  def count_attempt
    log_attempt
    if excessive_attempts?

    end
  end
end
