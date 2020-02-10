# frozen_string_literal: true

# Managing editable_pages
class EditablePagesController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # post /editable_pages/check
  def check
    @entity = EditablePage.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

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
      form_processed_ok(admin_editable_page_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /editable_pages/:id
  def destroy
    flash[:notice] = t('editable_pages.destroy.success') if @entity.destroy

    redirect_to(admin_editable_pages_path)
  end

  protected

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end

  def set_entity
    @entity = EditablePage.find_by(id: params[:id])
    handle_http_404('Cannot find editable_page') if @entity.nil?
  end

  def entity_parameters
    params.require(:editable_page).permit(EditablePage.entity_parameters)
  end
end
