class ForeignUsersController < AdminController
  before_action :set_entity, only: :destroy

  # delete /foreign_users/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('foreign_users.destroy.success')
    end
    redirect_to admin_foreign_users_path
  end

  private

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = ForeignUser.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find foreign_user')
    end
  end
end
