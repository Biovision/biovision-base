class Admin::EditableBlocksController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: [:index]

  # get /admin/editable_blocks
  def index
    @collection = EditableBlock.list_for_administration
  end

  # get /admin/editable_blocks/:id
  def show
  end

  private

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = EditableBlock.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find editable_block #{params[:id]}")
    end
  end
end
