# frozen_string_literal: true

# Handling user codes
class Admin::CodesController < AdminController
  include ListAndShowEntities
  include CreateAndModifyEntities

  before_action :set_entity, except: %i[check create index new]

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing codes is not allowed'
    handle_http_401(error) unless component_handler.allow?('manage_codes')
  end
end
