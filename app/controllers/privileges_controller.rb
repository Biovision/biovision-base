class PrivilegesController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /privileges
  def create
    @entity = Privilege.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_privilege_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /privileges/:id/edit
  def edit
  end

  # patch /privileges/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_privilege_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /privileges/:id
  def destroy
    if @entity.deletable? && @entity.destroy
      flash[:notice] = t('privileges.destroy.success')
    end
    redirect_to admin_privileges_path
  end

  private

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = Privilege.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find privilege #{params[:id]}")
    end
  end

  def entity_parameters
    params.require(:privilege).permit(Privilege.entity_parameters)
  end

  def creation_parameters
    params.require(:privilege).permit(Privilege.creation_parameters)
  end
end
