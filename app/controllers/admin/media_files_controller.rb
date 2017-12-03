class Admin::MediaFilesController < AdminController
  before_action :set_entity, except: [:index]

  # get /admin/media_files
  def index
    @collection = MediaFile.page_for_administration(current_page)
  end

  # get /admin/media_files/:id
  def show
  end

  private

  def set_entity
    @entity = MediaFile.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find media file')
    end
  end

  def restrict_access
    require_privilege_group :editorial_office
  end
end
