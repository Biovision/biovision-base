# frozen_string_literal: true

# Common class for managing Biovision Components
class ComponentManager
  attr_reader :entity, :slug, :name

  # @param [BiovisionComponent] entity
  def initialize(entity)
    @entity = entity
    @slug   = entity.slug
    @name   = I18n.t("biovision.components.#{@slug}.name", default: @slug)
  end

  # Receive component-specific handler by component slug
  #
  # @param [String] slug
  # @return [ComponentManager]
  def self.handler(slug)
    entity = BiovisionComponent.find_by!(slug: slug)

    handler_name  = "component_manager/#{slug}_handler".classify
    handler_class = handler_name.safe_constantize || ComponentManager
    handler_class.new(entity)
  end

  # @param [Hash] new_settings
  def settings=(new_settings)
    @entity.settings = @entity.settings.merge(normalize_settings(new_settings))
    @entity.save!
  end

  def settings
    @entity.settings
  end

  def parameters
    @entity.biovision_parameters.list_for_administration
  end

  # Get instance of BiovisionParameter with given slug
  #
  # @param [String] slug
  def parameter(slug)
    @entity.biovision_parameters.find_by(slug: slug)
  end

  # Create or update parameter values
  #
  # @param [String] slug
  # @param [String] value
  # @param [String] name
  # @param [String] description
  def set_parameter(slug, value, name = '', description = '')
    @entity[slug] = value

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
  # Returns value of component's parameter or default value when it's not found
  #
  # @param [String] key
  # @param [String] default
  # @return [String]
  def receive(key, default = '')
    @entity.receive!(key, default)
  end

  # Receive parameter value or nil
  #
  # Returns value of component's parameter of nil when it's not found
  #
  # @param [String] key
  # @return [String|nil]
  def [](key)
    @entity.receive(key)
  end

  # Set parameter
  #
  # @param [String] key
  # @param [String] value
  def []=(key, value)
    @entity[key] = value
  end

  protected

  # @param [Hash] new_settings
  # @return [Hash]
  def normalize_settings(new_settings)
    new_settings.to_h
  end
end
