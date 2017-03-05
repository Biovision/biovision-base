class Admin::BrowsersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/browsers
  def index
    @collection = Browser.page_for_administration(current_page)
  end

  # get /admin/browsers/:id
  def show
    @collection = @entity.agents.page_for_administration(current_page)
  end

  # post /api/browsers/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/browsers/:id/lock
  def lock
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/browsers/:id/lock
  def unlock
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
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
