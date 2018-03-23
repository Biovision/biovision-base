class UserManager
  attr_accessor :user

  # @param [User] user
  def initialize(user = nil)
    @user = user
  end

  # @param [Hash] parameters
  # @param [Hash] profile
  def self.create(parameters, profile)
    user = User.new(parameters)

    user.profile_data = UserProfileHandler.clean_parameters(profile)

    { user: user, profile: user.profile_data }
  end

  # @param [Hash] parameters
  # @param [Hash] profile
  def update(parameters, profile)
    raise 'User is not set' if @user.nil?
    parameters[:profile_data] = UserProfileHandler.clean_parameters(profile)

    @user.update(parameters)

    { user: @user, profile: @user.profile_data }
  end
end
