class LinkBlocksController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /link_blocks/check
  def check
    @entity = LinkBlock.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /link_blocks/new
  def new
    @entity = LinkBlock.new
  end

  # post /link_blocks
  def create
    @entity = LinkBlock.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_link_block_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /link_blocks/:id/edit
  def edit
  end

  # patch /link_blocks/:id
  def update
    if @entity.update(entity_parameters)
      flash[:notice] = t('link_blocks.update.success')
      form_processed_ok(admin_link_block_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /link_blocks/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('link_blocks.destroy.success')
    end
    redirect_to(admin_link_blocks_path)
  end

  protected

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = LinkBlock.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find link_block')
    end
  end

  def entity_parameters
    params.require(:link_block).permit(LinkBlock.entity_parameters)
  end
end
