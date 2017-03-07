class AdminController < ApplicationController
  before_action :restrict_access

  protected

  def restrict_access
    return if UserPrivilege.user_has_any_privilege?(current_user)
    handle_http_401("User #{current_user&.id} has no privileges")
  end
end
