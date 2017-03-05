class Admin::PrivilegeGroupsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]
  before_action :set_privilege, only: [:add_privilege, :remove_privilege]

  # get /admin/privilege_groups
  def index
    @collection = PrivilegeGroup.page_for_administration
  end

  # get /admin/privilege_groups/:id
  def show
    @collection = @entity.privileges.ordered_by_name
  end

  # put /admin/privilege_groups/:id/privileges/:privilege_id
  def add_privilege
    @entity.add_privilege(@privilege)

    render json: { data: { privilege_ids: @entity.privilege_ids } }
  end

  # delete /admin/privilege_groups/:id/privileges/:privilege_id
  def remove_privilege
    @entity.remove_privilege(@privilege)

    render json: { data: { privilege_ids: @entity.privilege_ids } }
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = PrivilegeGroup.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find privilege group')
    end
  end

  def set_privilege
    @privilege = Privilege.find_by(id: params[:privilege_id])
    if @entity.nil?
      handle_http_404('Cannot find privilege')
    end
  end
end
