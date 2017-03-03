class AgentsController < ApplicationController
  before_action :restrict_access
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
      redirect_to admin_agent_path(@entity)
    else
      render :new, status: :bad_request
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
      redirect_to admin_agent_path(@entity), notice: t('agents.update.success')
    else
      render :edit, status: :bad_request
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
    require_role :administrator
  end

  def set_entity
    @entity = Agent.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404('Agent is not found or was deleted')
    end
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_agent_path(@entity), alert: t('agents.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:agent).permit(Agent.entity_parameters)
  end
end
