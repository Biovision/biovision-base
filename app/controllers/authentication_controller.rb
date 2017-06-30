class AuthenticationController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user, except: [:new, :destroy]
  before_action :set_foreign_site, only: [:auth_callback]

  # get /login
  def new
  end

  # post /login
  def create
    @user    = User.find_by(slug: param_from_request(:login).downcase)
    @bouncer = UserBouncer.new(@user, tracking_for_entity)
    bounce_or_allow
  end

  # delete /logout
  def destroy
    deactivate_token if current_user
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
    if @foreign_site.nil?
      metric = Metric::METRIC_HTTP_503
      status = :service_unavailable
      handle_http_error('Cannot set foreign site', metric, status, status)
    end
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
    redirect_to my_path
  end

  def failed_authentication
    Metric.register(User::METRIC_AUTHENTICATION_FAILURE)
    flash.now[:alert] = t(:could_not_log_in)
    render :new, status: :unauthorized
  end
end
