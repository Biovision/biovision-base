# Adds list of toggleable attributes to model
#
# @author Maxim Khan-Magomedov <maxim.km@gmail.com>
module Toggleable
  extend ActiveSupport::Concern

  included do
    class_attribute :toggleable_attributes, instance_predicate: false, instance_accessor: false

    # @param [String, Symbol] attribute
    # @return [Hash]
    def toggle_parameter(attribute)
      return unless self::toggleable_attributes.include? attribute.to_sym
      toggle! attribute
      { attribute => self[attribute] }
    end
  end

  module ClassMethods

    private

    # @param [Array<Symbol, String>] attributes
    def toggleable(*attributes)
      cattr_accessor :toggleable_attributes
      self.toggleable_attributes = attributes.flatten
    end
  end
end
