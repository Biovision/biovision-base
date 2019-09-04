# frozen_string_literal: true

# Administrative part of editable_pages management
class Admin::EditablePagesController < AdminController
  include EntityPriority
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/editable_pages
  def index
    @collection = EditablePage.list_for_administration
  end

  # get /admin/editable_pages/:id
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
    @entity = EditablePage.find_by(id: params[:id])
    handle_http_404('Cannot find editable_page') if @entity.nil?
  end
end
