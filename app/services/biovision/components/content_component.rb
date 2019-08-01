# frozen_string_literal: true

module Biovision
  module Components
    # Component for content
    class ContentComponent < BaseComponent
      def allow?(options = {})
        UserPrivilege.user_has_privilege?(user, :content_manager)
      end
    end
  end
end
