class UserBouncer
  # @param [User] user
  # @param [Hash] tracking
  def initialize(user, tracking)
    @user     = user
    @tracking = tracking
  end

  # @param [String] password
  def let_user_in?(password)
    return false unless @user&.allow_login?
    @password = password
    excessive_attempts? ? (log_attempt && false) : try_password
  end

  private

  def excessive_attempts?
    LoginAttempt.owned_by(@user).since(15.minutes.ago) > 4
  end

  def log_attempt
    data = { user: @user, password: @password }
    LoginAttempt.create(data.merge(@tracking))
  end

  def try_password
    @user.authenticate(@password) || (count_attempt && false)
  end

  def count_attempt
    log_attempt
    if excessive_attempts?
      UserMailer.login_attempt(@user.id).deliver_later
    end
  end
end
