# frozen_string_literal: true

# Handling user tokens
class Admin::TokensController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/tokens
  def index
    @filter     = params[:filter] || {}
    @collection = Token.page_for_administration(current_page, @filter)
  end

  # get /admin/tokens/:id
  def show
  end

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing tokens is not allowed'
    handle_http_401(error) unless component_handler.administrator?
  end

  def set_entity
    @entity = Token.find_by(id: params[:id])
    handle_http_404('Cannot find token') if @entity.nil?
  end
end
