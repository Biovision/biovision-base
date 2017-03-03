class BrowsersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /browsers/new
  def new
    @entity = Browser.new
  end

  # post /browsers
  def create
    @entity = Browser.new entity_parameters
    if @entity.save
      redirect_to admin_browser_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /browsers/:id/edit
  def edit
  end

  # patch /browsers/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_browser_path(@entity), notice: t('browsers.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /browsers/:id
  def destroy
    if @entity.update! deleted: true
      flash[:notice] = t('browsers.destroy.success')
    end
    redirect_to admin_browsers_path
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Browser.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404('Browser is not found or was deleted')
    end
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_browser_path(@entity), alert: t('browsers.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:browser).permit(Browser.entity_parameters)
  end
end
