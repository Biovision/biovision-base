class Admin::BrowsersController < AdminController
  include LockableEntity
  include ToggleableEntity

  before_action :set_entity, except: [:index]
  before_action :check_entity_lock, only: [:toggle]

  # get /admin/browsers
  def index
    @collection = Browser.page_for_administration(current_page)
  end

  # get /admin/browsers/:id
  def show
    @collection = @entity.agents.page_for_administration(current_page)
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = Browser.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404('Browser is not found or was deleted')
    end
  end
end
