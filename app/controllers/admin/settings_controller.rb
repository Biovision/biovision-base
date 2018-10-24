# frozen_string_literal: true

# Administrative controller for managing component settings and parameters
class Admin::SettingsController < AdminController
  before_action :set_handler, except: :index

  # get /admin/settings
  def index
    @collection = BiovisionComponent.pluck(:slug)
  end

  # get /admin/settings/:slug
  def show
  end

  # patch /admin/settings/:slug
  def update
    new_settings      = params.dig(:component, :settings).permit!
    @handler.settings = new_settings.to_h
    flash[:notice]    = t('admin.settings.update.success')
    redirect_to(admin_component_path(slug: params[:slug]))
  end

  # put /admin/settings/:slug/:parameter_slug
  def set_parameter
    new_value = param_from_request(:key, :value)

    @handler[params[:parameter_slug]] = new_value

    head :no_content
  end

  # delete /admin/settings/:slug/:parameter_slug
  def delete_parameter
    @handler.delete_parameter(params[:parameter_slug])

    head :no_content
  end

  private

  def set_handler
    @handler = ComponentManager.handler(params[:slug])
  end
end
