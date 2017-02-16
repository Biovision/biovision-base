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
    end
  end
end