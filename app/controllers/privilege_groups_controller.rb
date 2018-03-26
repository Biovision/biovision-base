class PrivilegeGroupsController < AdminController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /privilege_groups/new
  def new
    @entity = PrivilegeGroup.new
  end

  # post /privilege_groups
  def create
    @entity = PrivilegeGroup.new entity_parameters
    if @entity.save
      redirect_to admin_privilege_group_path(id: @entity.id)
    else
      render :new, status: :bad_request
    end
  end

  # get /privilege_groups/:id/edit
  def edit
  end

  # patch /privilege_groups/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_privilege_group_path(id: @entity.id), notice: t('privilege_groups.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /privilege_groups/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('privilege_groups.destroy.success')
    end
    redirect_to admin_privilege_groups_path
  end

  private

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = PrivilegeGroup.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('PrivilegeGroup is not found')
    end
  end

  def entity_parameters
    params.require(:privilege_group).permit(PrivilegeGroup.entity_parameters)
  end
end
