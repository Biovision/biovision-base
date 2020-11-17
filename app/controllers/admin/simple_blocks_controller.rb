# frozen_string_literal: true

# Administrative part of simple_blocks management
class Admin::SimpleBlocksController < AdminController
  include ToggleableEntity
  include ListAndShowEntities
  include CreateAndModifyEntities

  before_action :set_entity, except: %i[check create index new]

  private

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end
end
