module Authentication
  extend ActiveSupport::Concern

  def redirect_authenticated_user
    redirect_to my_path unless current_user.nil?
  end

  # @param [User] user
  def create_token_for_user(user)
    token = user.tokens.create!(tracking_for_entity)

    cookies['token'] = {
      value: token.cookie_pair,
      expires: 1.year.from_now,
      domain: :all,
      httponly: true
    }
  end
end
