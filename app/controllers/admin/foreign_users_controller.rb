# frozen_string_literal: true

# Handling foreign users
class Admin::ForeignUsersController < AdminController
  before_action :set_entity, except: :index

  # get /admin/foreign_users
  def index
    @collection = ForeignUser.page_for_administration(current_page)
  end

  # get /admin/foreign_users/:id
  def show
  end

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing foreign users is not allowed'
    handle_http_401(error) unless component_handler.allow?('view', 'edit')
  end

  def set_entity
    @entity = ForeignUser.find_by(id: params[:id])
    handle_http_404('Cannot find foreign_user') if @entity.nil?
  end
end
