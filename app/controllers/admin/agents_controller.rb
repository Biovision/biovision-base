class Admin::AgentsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/agents
  def index
    @filter     = params[:filter] || Hash.new
    @collection = Agent.page_for_administration current_page, @filter
  end

  # get /admin/agents/:id
  def show
  end

  # post /api/agents/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/agents/:id/lock
  def lock
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/agents/:id/lock
  def unlock
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Agent.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404('Agent is not found or was deleted')
    end
  end
end
