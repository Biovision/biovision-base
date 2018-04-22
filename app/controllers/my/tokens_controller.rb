class My::TokensController < ProfileController
  include ToggleableEntity

  before_action :set_entity, except: [:index]

  # get /my
  def index
    @collection = Token.page_for_owner(current_user, current_page)
  end

  private

  def set_entity
    @entity = Token.owned_by(current_user).find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find token for current user')
    end
  end
end
