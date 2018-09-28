class BrowsersController < AdminController
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
      form_processed_ok(admin_browser_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /browsers/:id/edit
  def edit
  end

  # patch /browsers/:id
  def update
    if @entity.update entity_parameters
      form_processed_ok(admin_browser_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
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
    require_privilege :administrator
  end

  def set_entity
    @entity = Browser.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404('Browser is not found or was deleted')
    end
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_browser_path(id: @entity.id), alert: t('browsers.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:browser).permit(Browser.entity_parameters)
  end
end
