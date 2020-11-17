# frozen_string_literal: true

module Biovision
  module Components
    # Base biovision component
    class BaseComponent
      attr_reader :component, :slug, :name, :user, :user_link

      # @param [BiovisionComponent] component
      # @param [User|nil] user
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
        type = input.is_a?(String) ? input : input&.slug
        handler_class(type)[user]
      end

      def self.slug
        to_s.demodulize.to_s.underscore.gsub('_component', '')
      end

      # Receive component-specific handler by class name for component.
      #
      # e.g.: Biovision::Components::RegistrationComponent[user]
      #
      # @param [User|nil] user
      def self.[](user = nil)
        new(BiovisionComponent[slug], user)
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

      def self.setting_steps
        {}
      end

      # @param [ApplicationRecord] entity
      def self.form_options(entity)
        table_name = entity.class.table_name
        {
          model: entity,
          url: "/admin/#{table_name}/#{entity.id}",
          method: entity.id.nil? ? :post : :patch,
          html: {
            id: "#{entity.class.to_s.underscore}-form",
            data: { check_url: "/admin/#{table_name}/check" },
          }
        }
      end

      # @param [User] user
      # @param [String] privilege_name
      # @deprecated use instance method via self[user].allow?(privilege_name)
      def self.allow?(user, privilege_name = '')
        return false if user.nil?
        return true if user.super_user?

        self[user].allow?(privilege_name)
      end

      # @param [User] user
      def user=(user)
        @user = user

        criteria = { biovision_component: @component, user: user }

        @user_link = BiovisionComponentUser.find_by(criteria)
      end

      def user_link!(force_create = false)
        if @user_link.nil?
          criteria = { biovision_component: @component, user: user }
          @user_link = BiovisionComponentUser.new(criteria)
          @user_link.save if force_create
        end

        @user_link
      end

      def use_parameters?
        false
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
        return true if administrator? || (component.nil? && privileges.blank?)
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

      protected

      # @param [Hash] data
      # @return [Hash]
      def normalize_settings(data)
        data.to_h
      end
    end
  end
end
