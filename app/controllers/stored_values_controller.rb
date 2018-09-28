class StoredValuesController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /stored_values/new
  def new
    @entity = StoredValue.new
  end

  # post /stored_values
  def create
    @entity = StoredValue.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_stored_value_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /stored_values/:id/edit
  def edit
  end

  # patch /stored_values/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_stored_value_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /stored_values/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('stored_values.destroy.success')
    end
    redirect_to admin_stored_values_path
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = StoredValue.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find stored_value')
    end
  end

  def entity_parameters
    params.require(:stored_value).permit(StoredValue.entity_parameters)
  end
end
