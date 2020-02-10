# frozen_string_literal: true

# Handling user codes
class Admin::CodesController < AdminController
  before_action :set_entity, except: [:index]

  # get /admin/codes
  def index
    @collection = Code.page_for_administration current_page
  end

  # get /admin/codes/:id
  def show
  end

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing codes is not allowed'
    handle_http_401(error) unless component_handler.allow?('manage_codes')
  end

  def set_entity
    @entity = Code.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find code')
    end
  end
end
