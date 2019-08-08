# Adds method for validating model in controllers
#
# @author Maxim Khan-Magomedov <maxim.km@gmail.com>
module Checkable
  extend ActiveSupport::Concern

  included do
    # @param id
    # @param [Hash] parameters
    def self.instance_for_check(id, parameters)
      if id.blank?
        entity = new(parameters)
      else
        entity = find_by(id: id)
        entity.assign_attributes(parameters)
      end
      entity
    end
  end
end
