module Biovision
  module Base
    module PrivilegeMethods
      extend ActiveSupport::Concern

      included do
        helper_method :current_user_has_privilege?, :current_user_in_group?
      end

      # @param [Symbol] privilege_name
      def current_user_has_privilege?(privilege_name)
        ::UserPrivilege.user_has_privilege?(current_user, privilege_name)
      end

      # @param [Symbol] group_name
      def current_user_in_group?(group_name)
        ::UserPrivilege.user_in_group?(current_user, group_name)
      end

      protected

      # @param [Symbol] privilege_name
      def require_privilege(privilege_name)
        return if current_user_has_privilege?(privilege_name)
        handle_http_401("Current user has no privilege #{privilege_name}")
      end

      # @param [Symbol] group_name
      def require_privilege_group(group_name)
        return if current_user_in_group?(group_name)
        handle_http_401("Current user is not in group #{group_name}")
      end
    end
  end
end
