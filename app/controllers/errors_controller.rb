class ErrorsController < ApplicationController
  # /400
  def bad_request
    Metric.register(Metric::METRIC_HTTP_400)

    render :error, status: :bad_request
  end

  # /401
  def unauthorized
    Metric.register(Metric::METRIC_HTTP_401)

    render :error, status: :unauthorized
  end

  # /403
  def forbidden
    Metric.register(Metric::METRIC_HTTP_403)

    render :error, status: :forbidden
  end

  # /404
  def not_found
    Metric.register(Metric::METRIC_HTTP_404)

    render :error, status: :not_found
  end

  # 422
  def unprocessable_entity
    Metric.register(Metric::METRIC_HTTP_422)

    render :error, status: :unprocessable_entity
  end

  # /500
  def internal_server_error
    Metric.register(Metric::METRIC_HTTP_500)

    render :error, status: :internal_server_error
  end
end
