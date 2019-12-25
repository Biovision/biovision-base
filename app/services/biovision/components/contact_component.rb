# frozen_string_literal: true

module Biovision
  module Components
    # Component for feedback
    class ContactComponent < BaseComponent
      SLUG = 'contact'

      def self.privilege_names
        %w[feedback_manager]
      end

      def use_parameters?
        true
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
