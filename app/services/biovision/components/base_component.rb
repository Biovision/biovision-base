# frozen_string_literal: true

module Biovision
  module Components
    # Base biovision component
    class BaseComponent
      attr_reader :component, :slug, :name, :user

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
          entity = BiovisionComponent.find_by!(slug: input)
          handler_class(input).new(entity, user)
        end
      end

      # @param [String] slug
      def self.handler_class(slug)
        handler_name = "biovision/components/#{slug}_component".classify
        handler_name.safe_constantize || BaseComponent
      end

      def self.default_privilege_name
        self.class.to_s.demodulize.underscore.gsub('component', 'manager')
      end

      # @param [User] user
      # @param [Hash] options
      def self.allow?(user, options = {})
        return false if user.nil?

        privilege = options[:privilege] || default_privilege_name

        UserPrivilege.user_has_privilege?(user, privilege)
      end

      # @param [User] user
      def user=(user)
        @user = user

        criteria = {
          biovision_component: @component,
          user: user
        }

        @role = BiovisionComponentUser.find_by(criteria)
      end

      def use_parameters?
        true
      end

      # @param [Hash] options
      def allow?(options = {})
        return false if user.nil?
        return true if user.super_user? || @role&.administrator?

        if options.key?(:action)
          @role.data[options[:action].to_s]
        else
          !@role.nil?
        end
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

      protected

      # @param [Hash] data
      # @return [Hash]
      def normalize_settings(data)
        data.to_h
      end
    end
  end
end