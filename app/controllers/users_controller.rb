class UsersController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /users/new
  def new
    @entity = User.new
  end

  # post /users
  def create
    @entity = User.new(creation_parameters)
    if @entity.save
      redirect_to admin_user_path(@entity.id), notice: t('users.create.success')
    else
      render :new, status: :bad_request
    end
  end

  # get /users/:id/edit
  def edit
  end

  # patch /users/:id
  def update
    if @entity.update(entity_parameters)
      redirect_to admin_user_path(@entity.id), notice: t('users.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /users/:id
  def destroy
    if @entity.update(deleted: true)
      flash[:notice] = t('users.destroy.success')
    end
    redirect_to admin_users_path
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = User.find_by(id: params[:id])
  end

  def entity_parameters
    params.require(:user).permit(User.entity_parameters)
  end

  def creation_parameters
    params.require(:user).permit(User.entity_parameters).merge(tracking_for_entity)
  end
end
