# frozen_string_literal: true

# Adds methods for user authentication
module Authentication
  extend ActiveSupport::Concern

  def redirect_authenticated_user
    redirect_to my_path unless current_user.nil?
  end

  # @param [User] user
  def create_token_for_user(user)
    forced_user = User.find_by(id: user.native_id)
    user = forced_user unless forced_user.nil?

    token = user.tokens.create!(tracking_for_entity)

    self.token_cookie = token.cookie_pair
  end

  def deactivate_token
    token = Token.find_by(token: cookies['token'].split(':').last)
    token&.update(active: false)
    pop_token
  end

  def pop_token
    if cookies['pt']
      self.token_cookie = cookies['pt']
      cookies.delete 'pt', domain: :all
    else
      cookies.delete 'token', domain: :all
    end
  end

  def token_cookie=(value)
    cookies['token'] = {
      value: value,
      expires: 1.year.from_now,
      domain: :all,
      httponly: true
    }
  end
end
