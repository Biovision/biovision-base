# frozen_string_literal: true

# Administrative part of editable_pages management
class Admin::EditablePagesController < AdminController
  include ListAndShowEntities
  include EntityPriority
  include ToggleableEntity

  private

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end
end
