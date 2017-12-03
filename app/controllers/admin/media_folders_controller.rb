class Admin::MediaFoldersController < AdminController
  before_action :set_entity, except: [:index]

  # get /admin/media_folders
  def index
    @collection = MediaFolder.for_tree(params[:parent_id])
  end

  # get /admin/media_folders/:id
  def show
    @collection = MediaFolder.for_tree(@entity.id)
  end

  # get /admin/media_folders/:id/files
  def files
    @collection = @entity.media_files.page_for_administration(current_page)
  end

  private

  def set_entity
    @entity = MediaFolder.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find media folder')
    end
  end

  def restrict_access
    require_privilege_group :editors
  end
end
