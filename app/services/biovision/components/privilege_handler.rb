# frozen_string_literal: true

module Biovision
  module Components
    # Handling user privileges in component
    class PrivilegeHandler
      attr_accessor :component

      # @param [BaseComponent] component
      def initialize(component)
        @component = component
      end

      # @param [String|Symbol]
      def privilege?(slug)
        return false if @component.user_link.nil?

        privileges = Array(@component.user_link.data['privileges'])
        privileges.include?(slug)
      end

      def administrator!
        return if @component.user.nil?

        link = @component.user_link!
        link.administrator = true
        link.save
      end

      def not_administrator!
        return if @component.user.nil? || @component.user_link.nil?

        @component.user_link.update(administrator: false)
      end

      # @param [Array] new_privileges
      def privileges=(new_privileges)
        return if @component.user.nil?

        link = @component.user_link!
        link.data['privileges'] = Array(new_privileges).uniq
        link.save
      end

      # @param [Hash] new_settings
      def settings=(new_settings)
        return if @component.user.nil?

        link = @component.user_link!
        link.data['settings'] = new_settings
        link.save
      end

      # @param [String] slug
      def add_privilege(slug)
        return if @component.user.nil?

        link = @component.user_link!
        link.data['privileges'] ||= []
        link.data['privileges'] += [slug.to_s]
        link.data['privileges'].uniq!
        link.save
      end

      # @param [String] slug
      def remove_privilege(slug)
        link = @component.user_link

        return if link.nil?

        link.data['privileges'] ||= []
        link.data['privileges'] -= [slug.to_s]
        link.save
      end
    end
  end
end
