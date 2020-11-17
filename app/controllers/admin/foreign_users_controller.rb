# frozen_string_literal: true

# Handling foreign users
class Admin::ForeignUsersController < AdminController
  include ListAndShowEntities

  before_action :set_entity, except: :index

  # delete /admin/foreign_users/:id
  def destroy
    if component_handler.allow?('edit')
      flash[:notice] = t('.success') if @entity.destroy

      redirect_to admin_foreign_users_path
    else
      handle_http_401('Managing foreign users is not allowed')
    end
  end

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing foreign users is not allowed'
    handle_http_401(error) unless component_handler.allow?('view', 'edit')
  end
end
