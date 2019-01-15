# frozen_string_literal: true

# Handler for user profile parameters
class UserProfileHandler
  GENDERS = { 0 => 'female', 1 => 'male' }.freeze

  # List of attributes that can be used in user profile
  #
  # Change this method in decorators for other values
  def self.allowed_parameters
    %w[gender name patronymic surname about]
  end

  # Normalize profile parameters for storage
  #
  # Makes consistent format of profile hash.
  #
  # @param [Hash] input
  def self.clean_parameters(input)
    return {} unless input.respond_to?(:key?)

    output = normalized_parameters(input)
    (allowed_parameters - output.keys).each do |parameter|
      output[parameter] = input.key?(parameter) ? input[parameter].to_s : nil
    end
    output
  end

  # Prepare search string for simple user search
  #
  # @param [User] user
  def self.search_string(user)
    "#{user.data.dig('profile', 'surname')} #{user.data.dig('profile', 'name')}"
  end

  # Format parameters that have more restrictions than just "string" type
  #
  # Change this method in decorator to add other fields with type enumerable,
  # integer, etc.
  #
  # @param [Hash] input
  def self.normalized_parameters(input)
    { gender: clean_gender(input['gender']) }
  end

  # Restrict gender to only available values
  #
  # Defined gender is stored as integer.
  #
  # @param [Integer] input
  def self.clean_gender(input)
    gender_key = input.blank? ? nil : input.to_i
    GENDERS.key?(gender_key) ? gender_key : nil
  end
end
