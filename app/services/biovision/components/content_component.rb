# frozen_string_literal: true

module Biovision
  module Components
    # Component for content
    class ContentComponent < BaseComponent
      def self.privilege_names
        %w[content_manager]
      end
    end
  end
end
