# frozen_string_literal: true

# Managing user codes
class CodesController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # get /codes/new
  def new
    @entity = Code.new
  end

  # post /codes
  def create
    @entity = Code.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_code_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /codes/:id/edit
  def edit
  end

  # patch /codes/:id
  def update
    if @entity.update(entity_parameters)
      flash[:notice] = t('codes.update.success')
      form_processed_ok(admin_code_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /codes/:id
  def destroy
    flash[:notice] = t('codes.destroy.success') if @entity.destroy

    redirect_to admin_codes_path
  end

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing codes is not allowed'
    handle_http_401(error) unless component_handler.allow?('manage_codes')
  end

  def set_entity
    @entity = Code.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find code')
    end
  end

  def entity_parameters
    params.require(:code).permit(Code.entity_parameters)
  end

  def creation_parameters
    params.require(:code).permit(Code.creation_parameters)
  end
end
