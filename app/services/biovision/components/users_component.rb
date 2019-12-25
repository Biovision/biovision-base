# frozen_string_literal: true

module Biovision
  module Components
    # Component for handling users
    class UsersComponent < BaseComponent
      SLUG = 'users'

      def self.privilege_names
        %w[view edit manage_codes]
      end
    end
  end
end
