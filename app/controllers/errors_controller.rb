class ErrorsController < ApplicationController
  # /400
  def bad_request
    render :error, status: :bad_request
  end

  # /401
  def unauthorized
    render :error, status: :unauthorized
  end

  # /403
  def forbidden
    render :error, status: :forbidden
  end

  # /404
  def not_found
    render :error, status: :not_found
  end

  # 422
  def unprocessable_entity
    render :error, status: :unprocessable_entity
  end

  # /500
  def internal_server_error
    render :error, status: :internal_server_error
  end
end
