# frozen_string_literal: true

# Social interactions for current user
class My::SocialController < ProfileController
  # get /my/followees
  def followees
    @collection = UserSubscription.followees(current_user).page(current_page)
  end

  # get /my/followers
  def followers
    @collection = UserSubscription.followers(current_user).page(current_page)
  end
end
