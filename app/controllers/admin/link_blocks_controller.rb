class Admin::LinkBlocksController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: [:index]

  # get /admin/link_blocks
  def index
    @collection = LinkBlock.list_for_administration
  end

  # get /admin/link_blocks/:id
  def show
  end

  private

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = LinkBlock.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find link_block #{params[:id]}")
    end
  end
end
