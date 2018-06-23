class LinkBlockItemsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /admin/link_blocks/check
  def check
    @entity = LinkBlock.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /link_block_items/new
  def new
    @entity = LinkBlockItem.new
  end

  # post /link_block_items
  def create
    @entity = LinkBlockItem.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_link_block_item_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /link_block_items/:id/edit
  def edit
  end

  # patch /link_block_items/:id
  def update
    if @entity.update(entity_parameters)
      flash[:notice] = t('link_block_items.update.success')
      form_processed_ok(admin_link_block_item_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /link_block_items/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('link_block_items.destroy.success')
    end
    redirect_to(admin_link_block_items_path)
  end

  protected

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = LinkBlockItem.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find link_block_item')
    end
  end

  def entity_parameters
    params.require(:link_block_item).permit(LinkBlockItem.entity_parameters)
  end

  def creation_parameters
    params.require(:link_block_item).permit(LinkBlockItem.creation_parameters)
  end
end
