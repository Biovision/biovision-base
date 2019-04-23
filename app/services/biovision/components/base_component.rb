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