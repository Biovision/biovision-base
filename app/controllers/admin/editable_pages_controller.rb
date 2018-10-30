# frozen_string_literal: true

# Administrative part of editable pages management
class Admin::EditablePagesController < AdminController
  include EntityPriority
  include ToggleableEntity

  before_action :set_entity, except: [:index]

  # get /admin/editable_pages
  def index
    @collection = EditablePage.list_for_administration
  end

  # get /admin/editable_pages/:id
  def show
  end

  private

  def restrict_access
    require_privilege :content_manager
  end

  def set_entity
    @entity = EditablePage.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find editable_page #{params[:id]}")
    end
  end
end
