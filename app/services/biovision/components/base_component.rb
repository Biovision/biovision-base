# frozen_string_literal: true

module Biovision
  module Components
    # Base biovision component
    class BaseComponent
      attr_reader :component, :slug, :name, :user, :user_link

      # @param [BiovisionComponent] component
      # @param [User] user
      def initialize(component, user = nil)
        @component = component
        @slug = component&.slug || 'base'
        self.user = user

        @name = I18n.t("biovision.components.#{@slug}.name", default: @slug)
      end

      # Receive component-specific handler by component slug
      #
      # @param [String|BiovisionComponent] input
      # @param [User] user
      # @return [BaseComponent]
      def self.handler(input, user = nil)
        if input.is_a?(BiovisionComponent)
          handler_class(input.slug).new(input, user)
        else
          entity = BiovisionComponent.find_by(slug: input)
          handler_class(input).new(entity, user)
        end
      end

      # @param [String] slug
      def self.handler_class(slug)
        handler_name = "biovision/components/#{slug}_component".classify
        handler_name.safe_constantize || BaseComponent
      end

      # Privilege names for using in biovision_component_user.data
      def self.privilege_names
        []
      end

      # @param [User] user
      # @param [String] privilege_name
      def self.allow?(user, privilege_name = '')
        return false if user.nil?
        return true if user.super_user?

        slug = self.class.to_s.demodulize.underscore.gsub('component', '')
        component = BiovisionComponent.find_by(slug: slug)

        self.class.new(component, user).allow?(privilege_name)
      end

      # @param [User] user
      def user=(user)
        @user = user

        criteria = {
          biovision_component: @component,
          user: user
        }

        @user_link = BiovisionComponentUser.find_by(criteria)
      end

      def use_parameters?
        true
      end

      def use_settings?
        use_parameters? || @component.settings.any?
      end

      def administrator?
        return false if user.nil?

        user.super_user? || @user_link&.administrator?
      end

      # @param [String|Array] privileges
      def allow?(*privileges)
        return false if user.nil?
        return true if administrator?
        return true if component.nil? && privileges.blank?
        return false if @user_link.nil?

        result = privileges.blank?
        privileges.flatten.each { |slug| result |= privilege?(slug) }
        result
      end

      # @param [String] privilege_name
      def privilege?(privilege_name)
        privilege_handler.privilege?(privilege_name)
      end

      # @param [Hash] data
      def settings=(data)
        @component.settings.merge!(normalize_settings(data))
        @component.save!
      end

      def settings
        @component.settings
      end

      # Receive parameter value with default
      #
      # Returns value of component's parameter or default value
      # when it's not found
      #
      # @param [String] key
      # @param [String] default
      # @return [String]
      def receive(key, default = '')
        @component.get(key, default)
      end

      # Receive parameter value or nil
      #
      # Returns value of component's parameter of nil when it's not found
      #
      # @param [String] key
      # @return [String]
      def [](key)
        @component.get(key)
      end

      # Set parameter
      #
      # @param [String] key
      # @param [String] value
      def []=(key, value)
        @component[key] = value unless key.blank?
      end

      # @param [String] name
      # @param [Integer] quantity
      def register_metric(name, quantity = 1)
        metric = Metric.find_by(name: name)
        if metric.nil?
          attributes = {
            biovision_component: @component,
            name: name,
            incremental: !name.end_with?('.hit')
          }
          metric = Metric.create(attributes)
        end

        metric << quantity
      end

      def privilege_handler
        @privilege_handler ||= PrivilegeHandler.new(self)
      end

      # @param [User] user
      def update_privileges(user)
        criteria = {
          user: user,
          biovision_component: @component
        }
        BiovisionComponentUser.find_or_create_by(criteria)
      end

      protected

      # @param [Hash] data
      # @return [Hash]
      def normalize_settings(data)
        data.to_h
      end
    end
  end
end