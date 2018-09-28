class AgentsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /agents/new
  def new
    @entity = Agent.new
  end

  # post /agents
  def create
    @entity = Agent.new entity_parameters
    if @entity.save
      form_processed_ok(admin_agent_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /agents/:id
  def show
  end

  # get /agents/:id/edit
  def edit
  end

  # patch /agents/:id
  def update
    if @entity.update entity_parameters
      form_processed_ok(admin_agent_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /agents/:id
  def destroy
    if @entity.update! deleted: true
      flash[:notice] = t('agents.destroy.success')
    end
    redirect_to admin_agents_path
  end

  private

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = Agent.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404('Agent is not found or was deleted')
    end
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_agent_path(id: @entity.id), alert: t('agents.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:agent).permit(Agent.entity_parameters)
  end
end
