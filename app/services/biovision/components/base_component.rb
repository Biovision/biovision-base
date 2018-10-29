# frozen_string_literal: true

module Biovision
  module Components
    # Base biovision component
    class BaseComponent
      attr_reader :component, :slug, :name

      # @param [BiovisionComponent] component
      def initialize(component)
        @component = component
        @slug      = component.slug

        @name = I18n.t("biovision.components.#{@slug}.name", default: @slug)
      end

      # Receive component-specific handler by component slug
      #
      # @param [String] slug
      # @return [BaseComponent]
      def self.handler(slug)
        entity = BiovisionComponent.find_by!(slug: slug)

        handler_name  = "biovision/components/#{slug}_component".classify
        handler_class = handler_name.safe_constantize || BaseComponent
        handler_class.new(entity)
      end

      # @param [Hash] data
      def settings=(data)
        @component.settings.merge!(normalize_settings(data))
        @component.save!
      end

      def settings
        @component.settings
      end

      def parameters
        @component.biovision_parameters.list_for_administration
      end

      # Get instance of BiovisionParameter with given slug
      #
      # @param [String] slug
      def parameter(slug)
        @component.biovision_parameters.find_by(slug: slug)
      end

      # Create or update parameter values
      #
      # @param [String] slug
      # @param [String] value
      # @param [String] name
      # @param [String] description
      def set_parameter(slug, value, name = '', description = '')
        @component[slug] = value

        item = parameter(slug)
        item.update(name: name, description: description) if item.deletable?

        item
      end

      # Delete parameter with given slug (if it is deletable)
      #
      # @param [String] slug
      def delete_parameter(slug)
        item = parameter(slug)

        return unless item&.deletable?

        item.destroy
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
        @component.receive!(key, default)
      end

      # Receive parameter value or nil
      #
      # Returns value of component's parameter of nil when it's not found
      #
      # @param [String] key
      # @return [String|nil]
      def [](key)
        @component.receive(key)
      end

      # Set parameter
      #
      # @param [String] key
      # @param [String] value
      def []=(key, value)
        @component[key] = value
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