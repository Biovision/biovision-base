class Admin::AgentsController < AdminController
  include LockableEntity
  include ToggleableEntity

  before_action :set_entity, except: [:index]
  before_action :check_entity_lock, only: [:toggle]

  # get /admin/agents
  def index
    @filter     = params[:filter] || Hash.new
    @collection = Agent.page_for_administration current_page, @filter
  end

  # get /admin/agents/:id
  def show
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = Agent.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404('Agent is not found or was deleted')
    end
  end
end
