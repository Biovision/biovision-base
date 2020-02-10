# frozen_string_literal: true

# Viewing login attempts
class Admin::LoginAttemptsController < AdminController
  # get /admin/login_attempts
  def index
    @collection = LoginAttempt.page_for_administration(current_page)
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Viewing login attempts is not allowed'
    handle_http_401(error) unless component_handler.administrator?
  end
end
