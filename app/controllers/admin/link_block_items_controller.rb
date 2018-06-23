class Admin::LinkBlockItemsController < AdminController
  include ToggleableEntity
  include EntityPriority

  before_action :set_entity

  # get /admin/link_block_items/:id
  def show
  end

  private

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = LinkBlockItem.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find link_block_item #{params[:id]}")
    end
  end
end
