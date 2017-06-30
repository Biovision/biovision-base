class Admin::LoginAttemptsController < AdminController
  # get /admin/login_attempts
  def index
    @collection = LoginAttempt.page_for_administration(current_page)
  end
end
