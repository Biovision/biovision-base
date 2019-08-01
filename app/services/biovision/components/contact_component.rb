# frozen_string_literal: true

module Biovision
  module Components
    # Component for feedback
    class ContactComponent < BaseComponent
      def allow?(options = {})
        UserPrivilege.user_has_privilege?(user, :feedback_manager)
      end

      protected

      # @param [Hash] data
      # @return [Hash]
      def normalize_settings(data)
        result = {}
        allowed = %w[feedback_receiver]
        allowed.each { |f| result[f] = data[f].to_s }

        result
      end
    end
  end
end
