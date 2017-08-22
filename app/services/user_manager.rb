class UserManager
  attr_accessor :user

  # @param [User] user
  def initialize(user = nil)
    @user = user
  end

  # @param [Hash] user_parameters
  # @param [Hash] profile_parameters
  def self.create(user_parameters, profile_parameters)
    user = User.new(user_parameters)
    if user.save
      profile = user.user_profile.new(profile_parameters)
      profile.save
    else
      profile = nil
    end
    { user: user, profile: profile }
  end

  # @param [Hash] user_parameters
  # @param [Hash] profile_parameters
  def update(user_parameters, profile_parameters)
    raise 'User is not set' if @user.nil?
    @user.update(user_parameters)
    profile = @user.user_profile || @user.user_profile.create
    profile.update(profile_parameters)

    { user: @user, profile: profile }
  end
end
