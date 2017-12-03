class MediaFoldersController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]
  before_action :restrict_destroying, only: [:destroy]

  # post /media_folders
  def create
    @entity = MediaFolder.new(creation_parameters)
    if @entity.save
      next_page = admin_media_folder_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.json { render json: { links: { self: next_page } } }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /media_folders/:id/edit
  def edit
  end

  # patch /media_folders/:id
  def update
    if @entity.update(entity_parameters)
      next_page = admin_media_folder_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.json { render json: { links: { self: next_page } } }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /media_folders/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('media_folders.destroy.success')
    end
    redirect_to admin_media_folders_path
  end

  private

  def set_entity
    @entity = MediaFolder.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find post')
    end
  end

  def restrict_access
    require_privilege_group :editors
  end

  def restrict_editing
    unless @entity.editable_by?(current_user)
      handle_http_403('MediaFolder is not editable by current user')
    end
  end

  def restrict_destroying
    unless @entity.can_be_deleted?
      handle_http_403('MediaFolder cannot be deleted')
    end
  end

  def entity_parameters
    params.require(:media_folder).permit(MediaFolder.entity_parameters)
  end

  def creation_parameters
    parameters = params.require(:media_folder).permit(MediaFolder.creation_parameters)
    parameters.merge(owner_for_entity(true))
  end
end
