class My::LoginAttemptsController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my/login_attempts
  def index
    @collection = LoginAttempt.page_for_owner(current_user, current_page)
  end
end
