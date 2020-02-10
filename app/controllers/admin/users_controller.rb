# frozen_string_literal: true

# Handling users
class Admin::UsersController < AdminController
  include Authentication
  include ToggleableEntity

  before_action :set_entity, except: %i[index search]
  before_action :set_privilege, only: [:grant_privilege, :revoke_privilege]

  # get /admin/users
  def index
    @search     = param_from_request(:q)
    @collection = User.page_for_administration current_page, @search
  end

  # get /admin/users/:id
  def show
  end

  # get /admin/users/:id/tokens
  def tokens
    @collection = Token.owned_by(@entity).page_for_administration(current_page)
  end

  # get /admin/users/:id/codes
  def codes
    @collection = Code.owned_by(@entity).page_for_administration(current_page)
  end

  # get /admin/users/:id/privileges
  def privileges
  end

  # put /admin/users/:id/privileges/:privilege_id
  def grant_privilege
    @privilege.grant(@entity, params[:region_id])

    render json: { data: { user_privilege_ids: @entity.user_privilege_ids } }
  end

  # delete /admin/users/:id/privileges/:privilege_id
  def revoke_privilege
    @privilege.revoke(@entity, params[:region_id])

    render json: { data: { user_privilege_ids: @entity.user_privilege_ids } }
  end

  # get /admin/users/search
  def search
    query = param_from_request(:q)
    if query.blank?
      @collection = []
    else
      @collection = User.search(query).order('slug asc').first(10)
    end
  end

  # post /admin/users/:id/authenticate
  def authenticate
    cookies['pt'] = {
      value: cookies['token'],
      expires: 1.year.from_now,
      domain: :all,
      httponly: true
    }
    create_token_for_user(@entity)
    redirect_to my_path
  end

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def restrict_access
    error = 'Managing users is not allowed'
    handle_http_401(error) unless component_handler.allow?('view', 'edit')
  end

  def set_entity
    @entity = User.find_by(id: params[:id])
    handle_http_404('Cannot find user') if @entity.nil?
  end

  def set_privilege
    @privilege = Privilege.find_by(id: params[:privilege_id])
    if @privilege.nil?
      handle_http_404("Cannot use privilege #{params[:privilege_id]}")
    end
  end
end
