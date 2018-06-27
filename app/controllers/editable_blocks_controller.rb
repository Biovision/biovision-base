class EditableBlocksController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /editable_blocks/check
  def check
    @entity = EditableBlock.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /editable_blocks/new
  def new
    @entity = EditableBlock.new
  end

  # post /editable_blocks
  def create
    @entity = EditableBlock.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_editable_block_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /editable_blocks/:id/edit
  def edit
  end

  # patch /editable_blocks/:id
  def update
    if @entity.update(entity_parameters)
      flash[:notice] = t('editable_blocks.update.success')
      form_processed_ok(admin_editable_block_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /editable_blocks/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('editable_blocks.destroy.success')
    end
    redirect_to(admin_editable_blocks_path)
  end

  protected

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = EditableBlock.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find editable_block')
    end
  end

  def entity_parameters
    params.require(:editable_block).permit(EditableBlock.entity_parameters)
  end
end
