# frozen_string_literal: true

# Managing users
class UsersController < ApplicationController
  before_action :restrict_access, except: :check
  before_action :set_entity, only: %i[edit update destroy]

  layout 'admin', except: :check

  # post /users/check
  def check
    @entity = User.new(creation_parameters)
  end

  # get /users/new
  def new
    @entity = User.new(consent: true)
  end

  # post /users
  def create
    @entity = User.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_user_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /users/:id/edit
  def edit
  end

  # patch /users/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_user_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /users/:id
  def destroy
    flash[:notice] = t('users.destroy.success') if @entity.destroy #update(deleted: true)

    redirect_to admin_users_path
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

  def entity_parameters
    parameters = params.require(:user).permit(User.entity_parameters)
    parameters.merge(data: @entity.data.merge(profile: profile_parameters))
  end

  def creation_parameters
    parameters = params.require(:user).permit(User.entity_parameters)

    parameters[:consent] = true
    parameters[:data]    = { profile: profile_parameters }

    parameters.merge(tracking_for_entity)
  end

  def profile_parameters
    if params.key?(:user_profile)
      permitted = UserProfileHandler.allowed_parameters
      dirty     = params.require(:user_profile).permit(permitted)
      UserProfileHandler.clean_parameters(dirty)
    else
      {}
    end
  end
end
