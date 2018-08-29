class MediaFilesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :ckeditor

  before_action :restrict_anonymous_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  layout 'admin', except: :ckeditor

  # get /media_files/new
  def new
    @entity = MediaFile.new
  end

  # post /media_files
  def create
    @entity = MediaFile.new(creation_parameters)
    if @entity.save
      next_page = admin_media_file_path(id: @entity.id)
      respond_to do |format|
        format.html { redirect_to(next_page) }
        format.json { render json: { links: { self: next_page } } }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /media_files/:id/edit
  def edit
  end

  # patch /media_files/:id
  def update
    if @entity.update entity_parameters
      next_page = admin_media_file_path(id: @entity.id)
      respond_to do |format|
        format.html { redirect_to(next_page, notice: t('media_files.update.success')) }
        format.json { render json: { links: { self: next_page } } }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /media_files/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('media_files.destroy.success')
    end
    redirect_to(admin_media_files_path)
  end

  def ckeditor
    parameters = {
      file:          params[:upload],
      snapshot:      params[:upload],
      name:          params[:upload].original_filename,
      original_name: params[:upload].original_filename,
    }.merge(owner_for_entity(true))

    @entity = MediaFile.create!(parameters)

    if params[:CKEditorFuncNum]
      render layout: false
    else
      render json: {
        uploaded: 1,
        fileName: File.basename(@entity.name),
        url:      @entity.file.medium_2x.url
      }
    end
  end

  # post /media_files/medium
  def medium
    @entity = MediaFile.create!(medium_image_parameters)
  end

  # post /media_files/medium-jquery
  def medium_jquery
    files = []
    if params.key?(:files)
      params[:files].each do |file|
        files << MediaFile.create(name: "image-#{Time.now.strftime('%F-%H-%M-%S')}", file: file)
      end
    end
    render json: { files: files.map { |f| { url: f.file.medium_2x.url } } }
  end

  protected

  def restrict_access
    require_privilege_group :editors
  end

  def restrict_upload
    require_privilege_group :editorial_office
  end

  def restrict_editing
    unless @entity.editable_by?(current_user)
      redirect_to admin_media_file_path(id: @entity.id), alert: t('media_files.edit.forbidden')
    end
  end

  def set_entity
    @entity = MediaFile.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find media_file')
    end
  end

  def entity_parameters
    params.require(:media_file).permit(MediaFile.entity_parameters)
  end

  def creation_parameters
    media_file = params.require(:media_file)
    parameters = media_file.permit(MediaFile.creation_parameters)
    if media_file[:file]
      file = media_file[:file]
      parameters.merge!(snapshot: file, original_name: file.original_filename)
    end
    parameters.merge(owner_for_entity(true))
  end

  def medium_image_parameters
    default_name = { name: "image-#{Time.now.strftime('%F-%H-%M-%S')}" }
    parameters   = params.require(:media_file).permit(:file)

    parameters.merge(default_name).merge(owner_for_entity(true))
  end
end
