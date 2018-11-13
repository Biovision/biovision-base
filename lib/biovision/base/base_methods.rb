# frozen_string_literal: true

module Biovision
  module Base
    # Useful methods and helpers for ApplicationController
    module BaseMethods
      extend ActiveSupport::Concern

      included do
        before_action :set_locale

        helper_method :current_page, :param_from_request
        helper_method :current_user, :current_language
        helper_method :agent, :visitor_slug
      end

      # Get current page number from request
      #
      # @return [Integer]
      def current_page
        @current_page ||= (params[:page] || 1).to_s.to_i.abs
      end

      # Get parameter from request and normalize it
      #
      # Casts request parameter to UTF-8 string and removes invalid characters
      #
      # @param [Symbol] param
      # @return [String]
      def param_from_request(*param)
        value = params.dig(*param)
        value.to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
      end

      # Get current user from token cookie
      #
      # @return [User|nil]
      def current_user
        @current_user ||= Token.user_by_token(cookies['token'], true)
      end

      # Get current language from locale
      #
      # @return [Language]
      def current_language
        @current_language ||= Language.find_by(code: locale)
      end

      # @return [Agent]
      def agent
        @agent ||= Agent.named(request.user_agent || 'n/a')
      end

      # @return [String]
      def visitor_slug
        if current_user.nil?
          "#{request.env['HTTP_X_REAL_IP'] || request.remote_ip}:#{agent.id}"
        else
          current_user.id.to_s
        end
      end

      def set_locale
        I18n.locale = params[:locale] || I18n.default_locale
      end

      protected

      # Handle HTTP error with status 404 without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [Symbol|String] view
      def handle_http_404(message, metric = nil, view = :not_found)
        status         = :not_found
        default_metric = Metric::METRIC_HTTP_404
        handle_http_error(message, metric || default_metric, view, status)
      end

      # Handle HTTP error with status 401 without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [Symbol|String] view
      def handle_http_401(message, metric = nil, view = :unauthorized)
        status         = :unauthorized
        default_metric = Metric::METRIC_HTTP_401
        handle_http_error(message, metric || default_metric, view, status)
      end

      # Handle HTTP error with status 503 without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [Symbol|String] view
      def handle_http_503(message, metric = nil, view = :service_unavailable)
        status         = :service_unavailable
        default_metric = Metric::METRIC_HTTP_503
        handle_http_error(message, metric || default_metric, view, status)
      end

      # Handle generic HTTP error without raising exception
      #
      # @param [String] message
      # @param [String] metric
      # @param [String|Symbol] view
      # @param [Symbol] status
      def handle_http_error(message, metric, view = :error, status = 500)
        logger.warn "#{message}\n\t#{request.method} #{request.original_url}"
        Metric.register(metric)
        render view, status: status
      end

      # Restrict access for anonymous users
      def restrict_anonymous_access
        handle_http_401('Restricted anonymous access') if current_user.nil?
      end

      # Owner information for entity
      #
      # @param [Boolean] track
      def owner_for_entity(track = false)
        result = { user: current_user }
        result.merge!(tracking_for_entity) if track
        result
      end

      # @return [Hash]
      def tracking_for_entity
        {
          agent: agent,
          ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip
        }
      end

      # @param [String] next_page
      def form_processed_ok(next_page)
        respond_to do |format|
          format.js { render(js: "document.location.href = '#{next_page}'") }
          format.html { redirect_to(next_page) }
        end
      end

      # @param [Symbol|String] view_to_render
      def form_processed_with_error(view_to_render)
        respond_to do |format|
          format.js { render('shared/forms/errors', status: :bad_request) }
          format.html { render(view_to_render, status: :bad_request) }
        end
      end
    end
  end
end
