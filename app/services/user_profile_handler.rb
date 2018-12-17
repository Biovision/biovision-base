class UserProfileHandler
  GENDERS = { 0 => 'female', 1 => 'male' }.freeze

  def self.allowed_parameters
    %w[gender name patronymic surname about]
  end

  # @param [Hash] input
  def self.clean_parameters(input)
    if input.key?('gender')
      gender_key = input['gender'].blank? ? nil : input['gender'].to_i
      gender     = GENDERS.key?(gender_key) ? gender_key : nil
    else
      gender = nil
    end

    output = { gender: gender }
    (allowed_parameters - ['gender']).each do |parameter|
      output[parameter] = input.key?(parameter) ? input[parameter].to_s : nil
    end
    output
  end

  # @param [User] user
  def self.search_string(user)
    "#{user.data.dig('profile', 'surname')} #{user.data.dig('profile', 'name')}"
  end
end
