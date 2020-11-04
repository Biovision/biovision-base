# frozen_string_literal: true

# Handling foreign users
class Admin::ForeignUsersController < AdminController
  include ListAndShowEntities

  before_action :set_entity, except: :index

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing foreign users is not allowed'
    handle_http_401(error) unless component_handler.allow?('view', 'edit')
  end
end
