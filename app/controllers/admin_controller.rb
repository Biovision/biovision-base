# frozen_string_literal: true

# Common administrative controller
class AdminController < ApplicationController
  before_action :restrict_access

  protected

  def restrict_access
    error = "User #{current_user&.id} has no privileges"

    handle_http_401(error) unless component_handler.allow?
  end
end
