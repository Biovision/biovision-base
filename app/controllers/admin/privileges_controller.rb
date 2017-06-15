class Admin::PrivilegesController < AdminController
  include LockableEntity
  include EntityPriority

  before_action :set_entity, except: [:index]

  # get /admin/privileges
  def index
    @collection = Privilege.for_tree
  end

  # get /admin/privileges/:id
  def show
  end

  # get /admin/privileges/:id/users
  def users
    @collection = @entity.users.page_for_administration(current_page)
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = Privilege.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted privilege #{params[:id]}")
    end
  end
end
