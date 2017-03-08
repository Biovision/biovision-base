class AuthenticationController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user, except: [:destroy]

  # get /login
  def new
  end

  # post /login
  def create
    user = User.find_by(slug: params[:login].to_s.downcase)
    if user.is_a?(User) && user.authenticate(params[:password].to_s) && user.allow_login?
      create_token_for_user(user, tracking_for_entity)
      Metric.register(User::METRIC_AUTHENTICATION_SUCCESS)
      redirect_to root_path
    else
      Metric.register(User::METRIC_AUTHENTICATION_FAILURE)
      flash.now[:alert] = t(:could_not_log_in)
      render :new, status: :unauthorized
    end
  end

  # delete /logout
  def destroy
    deactivate_token if current_user
    redirect_to root_path
  end

  private

  def deactivate_token
    token = Token.find_by token: cookies['token'].split(':').last
    token.update active: false
    cookies['token'] = nil
  end
end
