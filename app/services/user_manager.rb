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

    user.data['profile'] = UserProfileHandler.clean_parameters(profile)

    { user: user, profile: user.data['profile'] }
  end

  # @param [Hash] parameters
  # @param [Hash] profile
  def update(parameters, profile)
    raise 'User is not set' if @user.nil?

    parameters['data'] = @user.data.merge(profile: UserProfileHandler.clean_parameters(profile))

    @user.update(parameters)

    { user: @user, profile: @user.data['profile'] }
  end
end
