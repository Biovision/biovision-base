# frozen_string_literal: true

# Managing simple_blocks
class SimpleBlocksController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # post /simple_blocks/check
  def check
    @entity = SimpleBlock.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /simple_blocks/new
  def new
    @entity = SimpleBlock.new
  end

  # post /simple_blocks
  def create
    @entity = SimpleBlock.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_simple_block_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /simple_blocks/:id/edit
  def edit
  end

  # patch /simple_blocks/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_simple_block_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /simple_blocks/:id
  def destroy
    flash[:notice] = t('simple_blocks.destroy.success') if @entity.destroy

    redirect_to(admin_simple_blocks_path)
  end

  protected

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = SimpleBlock.find_by(id: params[:id])
    handle_http_404('Cannot find simple_block') if @entity.nil?
  end

  def entity_parameters
    params.require(:simple_block).permit(SimpleBlock.entity_parameters)
  end
end
