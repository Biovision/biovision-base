class Admin::TokensController < AdminController
  before_action :set_entity, except: [:index]

  # get /admin/tokens
  def index
    @collection = Token.page_for_administration(current_page)
  end

  # get /admin/tokens/:id
  def show
  end

  # post /admin/tokens/:id/toggle
  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = Token.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find token')
    end
  end
end
