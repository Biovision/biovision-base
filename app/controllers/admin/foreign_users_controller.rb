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
