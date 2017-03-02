module Biovision
  module Base
    module BaseMethods
      extend ActiveSupport::Concern

      included do
        helper_method :current_page, :param_from_request
      end

      # Get current page number from request
      #
      # @return [Integer]
      def current_page
        @current_page ||= (params[:page] || 1).to_s.to_i.abs
      end

      # Get parameter from request and normalize it
      #
      # Casts request parameter to UTF-8 string end removes invalid characters
      #
      # @param [Symbol] param
      # @return [String]
      def param_from_request(param)
        params[param].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
      end

      protected

      # Handle HTTP error with status 404 without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [Symbol|String] view
      def handle_http_404(message, metric = nil, view = :not_found)
        logger.warn "#{message}\n\t#{request.method} #{request.original_url}"
        Metric.register(metric || Metric::METRIC_HTTP_404)
        render view, status: :not_found
      end

      # Handle HTTP error with status 401 without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [Symbol|String] view
      def handle_http_401(message, metric = nil, view = :unauthorized)
        logger.warn "#{message}\n\t#{request.method} #{request.original_url}"
        Metric.register(metric || Metric::METRIC_HTTP_401)
        render view, status: :unauthorized
      end

      def agent
        @agent ||= Agent.named(request.user_agent || 'n/a')
      end

      def tracking_for_entity
        { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
      end
    end
  end
end