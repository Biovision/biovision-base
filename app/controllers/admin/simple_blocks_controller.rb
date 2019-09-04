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

  def component_slug
    Biovision::Components::ContentComponent::SLUG
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end

  def set_entity
    @entity = SimpleBlock.find_by(id: params[:id])
    handle_http_404('Cannot find simple_block') if @entity.nil?
  end
end
