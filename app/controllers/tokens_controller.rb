class TokensController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /tokens/new
  def new
    @entity = Token.new
  end

  # post /tokens
  def create
    @entity = Token.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_token_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /tokens/:id/edit
  def edit
  end

  # patch /tokens/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_token_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /tokens/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('tokens.destroy.success')
    end
    redirect_to admin_tokens_path
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
    if @entity.nil?
      handle_http_404('Cannot find token')
    end
  end

  def entity_parameters
    params.require(:token).permit(Token.entity_parameters)
  end

  def creation_parameters
    params.require(:token).permit(Token.creation_parameters).merge(tracking_for_entity)
  end
end
