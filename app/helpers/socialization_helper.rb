# frozen_string_literal: true

# Helper methods for socialization component
module SocializationHelper
  # @param [User] user
  # @param [String] text
  # @param [Hash] options
  def my_messages_link(user, text = user.profile_name, options = {})
    link_to(text, user_my_messages_path(slug: user.screen_name), options)
  end
end
