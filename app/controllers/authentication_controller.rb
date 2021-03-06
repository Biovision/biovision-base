# frozen_string_literal: true

# Authentication with form and OAuth
class AuthenticationController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user, except: %i[new destroy]
  before_action :set_foreign_site, only: :auth_callback

  # get /login
  def new
  end

  # post /login
  def create
    @user    = find_user
    @bouncer = UserBouncer.new(@user, tracking_for_entity)
    bounce_or_allow
  end

  # delete /logout
  def destroy
    deactivate_token if current_user

    cleanup_after_destroy
    redirect_to root_path
  end

  # get /auth/:provider/callback
  def auth_callback
    data = request.env['omniauth.auth']
    user = @foreign_site.authenticate(data, tracking_for_entity)
    create_token_for_user(user) if user.allow_login?

    redirect_to my_path
  end

  private

  def set_foreign_site
    @foreign_site = ForeignSite.with_slug(params[:provider]).first

    handle_http_503('Cannot set foreign site') if @foreign_site.nil?
  end

  def bounce_or_allow
    if @bouncer.let_user_in?(param_from_request(:password))
      successful_authentication
    else
      failed_authentication
    end
  end

  def successful_authentication
    create_token_for_user(@user)
    Metric.register(User::METRIC_AUTHENTICATION_SUCCESS)
    redirect_after_success
  end

  def failed_authentication
    Metric.register(User::METRIC_AUTHENTICATION_FAILURE)
    flash.now[:alert] = t(:could_not_log_in)
    render :new, status: :unauthorized
  end

  def redirect_after_success
    @return_path = cookies['return_path'].to_s
    @return_path = my_path unless @return_path[0] == '/'
    cookies.delete 'return_path', domain: :all

    respond_to do |format|
      format.json
      format.js { render(js: "document.location.href = '#{@return_path}'") }
      format.html { redirect_to(@return_path) }
    end
  end

  def find_user
    login = param_from_request(:login).downcase
    user  = User.find_by(slug: login)

    # Try to authenticate by email, if login does not match anything
    if user.nil? && login.index('@').to_i.positive?
      user = User.with_email(login).first
    end

    user
  end

  # Clean obsolete cookies, session parameters, etc.
  def cleanup_after_destroy
    # this method can be redefined in decorators
  end
end
