class PrivilegesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # post /privileges
  def create
    @entity = Privilege.new(creation_parameters)
    if @entity.save
      cache_relatives
      redirect_to admin_privilege_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /privileges/:id/edit
  def edit
  end

  # patch /privileges/:id
  def update
    if @entity.update(entity_parameters)
      cache_relatives
      redirect_to admin_privilege_path(@entity), notice: t('privileges.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /privileges/:id
  def destroy
    if @entity.update deleted: true
      flash[:notice] = t('privileges.destroy.success')
    end
    redirect_to admin_privileges_path
  end

  private

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = Privilege.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted privilege #{params[:id]}")
    end
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_privilege_path(@entity), alert: t('privileges.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:privilege).permit(Privilege.entity_parameters)
  end

  def creation_parameters
    params.require(:privilege).permit(Privilege.creation_parameters)
  end

  def cache_relatives
    @entity.cache_parents!
    unless @entity.parent.blank?
      parent = @entity.parent
      parent.cache_children!
      parent.save
    end
  end
end
