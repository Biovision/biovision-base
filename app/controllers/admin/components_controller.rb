# frozen_string_literal: true

# Handling components
class Admin::ComponentsController < AdminController
  before_action :set_handler, except: :index

  # get /admin/components
  def index
    @collection = BiovisionComponent.list_for_administration
  end

  # get /admin/components/:slug
  def show
    handle_http_401('Viewing component is not allowed') unless @handler.allow?
  end

  # get /admin/components/:slug/settings
  def settings
  end

  # patch /admin/components/:slug/settings
  def update_settings
    new_settings = params.dig(:component, :settings).permit!
    @handler.settings = new_settings.to_h
    flash[:notice] = t('admin.components.update_settings.success')
    redirect_to(admin_component_settings_path(slug: params[:slug]))
  end

  # patch /admin/components/:slug/parameters
  def update_parameter
    slug = param_from_request(:key, :slug).downcase
    value = param_from_request(:key, :value)

    @handler[slug] = value

    head :no_content
  end

  # delete /admin/components/:slug/parameters/:parameter_slug
  def delete_parameter
    @handler.component.parameters.delete(params[:parameter_slug])
    @handler.component.save

    head :no_content
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
end
