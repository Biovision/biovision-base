class EditablePagesController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /editable_pages/new
  def new
    @entity = EditablePage.new
  end

  # post /editable_pages
  def create
    @entity = EditablePage.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_editable_page_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /editable_pages/:id/edit
  def edit
  end

  # patch /editable_pages/:id
  def update
    if @entity.update(entity_parameters)
      flash[:notice] = t('editable_pages.update.success')
      form_processed_ok(admin_editable_page_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /editable_pages/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('editable_pages.destroy.success')
    end
    redirect_to(admin_editable_pages_path)
  end

  protected

  def restrict_access
    require_privilege :chief_editor
  end

  def set_entity
    @entity = EditablePage.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find editable_page')
    end
  end

  def entity_parameters
    params.require(:editable_page).permit(EditablePage.entity_parameters)
  end
end
