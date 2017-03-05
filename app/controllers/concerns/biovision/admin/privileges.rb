module Biovision::Admin::Privileges
  extend ActiveSupport::Concern

  included do
    before_action :restrict_access
    before_action :set_entity, except: [:index]
  end

  # get /admin/privileges
  def index
    @collection = ::Privilege.for_tree
  end

  # get /admin/privileges/:id
  def show
  end

  # get /admin/privileges/:id/users
  def users
    @collection = User.with_privilege(@entity).distinct.page_for_administration(current_page)
  end

  # put /api/privileges/:id/lock
  def lock
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/privileges/:id/lock
  def unlock
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  # post /api/privileges/:id/priority
  def priority
    render json: { data: @entity.change_priority(params[:delta].to_s.to_i) }
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = ::Privilege.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted privilege #{params[:id]}")
    end
  end
end
