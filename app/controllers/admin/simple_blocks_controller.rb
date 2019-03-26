# frozen_string_literal: true

# Administrative part of simple_blocks management
class Admin::SimpleBlocksController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/simple_blocks
  def index
    @collection = SimpleBlock.list_for_administration
  end

  # get /admin/simple_blocks/:id
  def show
  end

  private

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = SimpleBlock.find_by(id: params[:id])
    handle_http_404('Cannot find simple_block') if @entity.nil?
  end
end
