# frozen_string_literal: true

# Handling foreign users
class ForeignUsersController < AdminController
  before_action :set_entity, only: :destroy

  # delete /foreign_users/:id
  def destroy
    flash[:notice] = t('foreign_users.destroy.success') if @entity.destroy

    redirect_to admin_foreign_users_path
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing foreign users is not allowed'
    handle_http_401(error) unless component_handler.allow?('edit')
  end

  def set_entity
    @entity = ForeignUser.find_by(id: params[:id])
    handle_http_404('Cannot find foreign_user') if @entity.nil?
  end
end
