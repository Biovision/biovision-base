# frozen_string_literal: true

# Handling components
class Admin::ComponentsController < AdminController
  before_action :set_handler, except: :index
  skip_before_action :verify_authenticity_token, only: :ckeditor

  # get /admin/components
  def index
    @collection = BiovisionComponent.list_for_administration
  end

  # get /admin/components/:slug
  def show
    error = 'Viewing component is not allowed'
    handle_http_401(error) unless @handler.allow?
  end

  # get /admin/components/:slug/settings
  def settings
    error = 'Viewing settings is not allowed'
    handle_http_401(error) unless @handler.allow?('settings')
  end

  # patch /admin/components/:slug/settings
  def update_settings
    if @handler.allow?('settings')
      new_settings = params.dig(:component, :settings).permit!
      @handler.settings = new_settings.to_h
      flash[:notice] = t('admin.components.update_settings.success')
      redirect_to(admin_component_settings_path(slug: params[:slug]))
    else
      handle_http_401('Changing settings is not allowed')
    end
  end

  # patch /admin/components/:slug/parameters
  def update_parameter
    if @handler.allow?('settings')
      slug = param_from_request(:key, :slug).downcase
      value = param_from_request(:key, :value)

      @handler[slug] = value
    end

    head :no_content
  end

  # delete /admin/components/:slug/parameters/:parameter_slug
  def delete_parameter
    if @handler.allow?('settings')
      @handler.component.parameters.delete(params[:parameter_slug])
      @handler.component.save
    end

    head :no_content
  end

  # get /admin/components/:slug/privileges
  def privileges
    error = 'Viewing privileges is not allowed'
    handle_http_401(error) unless @handler.administrator?
  end

  # patch /admin/components/:slug/privileges
  def update_privileges
    if @handler.administrator?
      user = User.find_by(id: params[:user_id])

      if user.nil?
        handle_http_404('Cannot find user') if user.nil?
      else
        @entity = @handler.user_link!(true)
      end
    else
      handle_http_401('Updating privileges is not allowed')
    end
  end

  # put /admin/components/:slug/administrators/:user_id
  def add_administrator
    if @handler.administrator?
      @handler.user = User.find_by(id: params[:user_id])
      @handler.privilege_handler.administrator!
    end

    head :no_content
  end

  # put /admin/components/:slug/administrators/:user_id
  def remove_administrator
    if @handler.administrator?
      @handler.user = User.find_by(id: params[:user_id])
      @handler.privilege_handler.not_administrator!
    end

    head :no_content
  end

  # put /admin/components/:slug/users/:user_id/privileges/:privilege_slug
  def add_privilege
    if @handler.administrator?
      @handler.user = User.find_by(id: params[:user_id])
      @handler.privilege_handler.add_privilege(params[:privilege_slug])
    end

    head :no_content
  end

  # put /admin/components/:slug/users/:user_id/privileges/:privilege_slug
  def remove_privilege
    if @handler.administrator?
      @handler.user = User.find_by(id: params[:user_id])
      @handler.privilege_handler.remove_privilege(params[:privilege_slug])
    end

    head :no_content
  end

  # get /admin/components/:slug/images
  def images
    list = SimpleImage.in_component(@handler.component).list_for_administration
    @collection = @handler.allow? ? list.page(current_page) : []
  end

  def create_image
    if @handler.allow?
      @entity = @handler.component.simple_images.new(image_parameters)
      if @entity.save
        render 'image', formats: :json
      else
        form_processed_with_error(:new_image)
      end
    else
      handle_http_401('Uploading images is not allowed for current user')
    end
  end

  # post /admin/components/:slug/ckeditor
  def ckeditor
    parameters = {
      image: params[:upload],
      biovision_component: @handler.component
    }.merge(owner_for_entity(true))

    @entity = SimpleImage.create!(parameters)

    render json: {
      uploaded: 1,
      fileName: File.basename(@entity.image.path),
      url: @entity.image.medium_url
    }
  end

  private

  def set_handler
    slug = params[:slug]
    @handler = Biovision::Components::BaseComponent.handler(slug, current_user)
  end

  def restrict_access
    return if current_user&.super_user?

    links_exist = BiovisionComponentUser.where(user: current_user).exists?
    handle_http_401('User has no component privileges') unless links_exist
  end

  def image_parameters
    permitted = SimpleImage.entity_parameters
    params.require(:simple_image).permit(permitted)
    permitter.merge(owner_for_entity(true))
  end
end
