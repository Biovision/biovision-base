class My::ProfilesController < ApplicationController
  include Authentication

  before_action :redirect_authorized_user, only: [:new, :create]
  before_action :restrict_anonymous_access, except: [:new, :create]

  # get /my/profile/new
  def new
    @user = User.new
  end

  # post /my/profile
  def create
    if params[:agree]
      redirect_to root_path, alert: t('my.profiles.create.are_you_bot')
    else
      create_user
    end
  end

  # get /my/profile
  def show
  end

  # get /my/profile/edit
  def edit
  end

  # patch /my/profile
  def update
    if current_user.update(user_parameters)
      current_user.user_profile.update(profile_parameters)
      next_url       = my_profile_path
      flash[:notice] = t('my.profiles.update.success')
      respond_to do |format|
        format.js { render(js: "document.location.href = '#{next_url}'") }
        format.html { redirect_to(next_url) }
      end
    else
      render :edit, status: :bad_request
    end
  end

  protected

  def redirect_authorized_user
    redirect_to my_profile_path if current_user.is_a? User
  end

  def create_user
    @user = User.new creation_parameters
    if @user.save
      Metric.register(User::METRIC_REGISTRATION)
      create_token_for_user(@user)
      redirect_after_creation
    else
      render :new, status: :bad_request
    end
  end

  def creation_parameters
    parameters = params.require(:user).permit(User.new_profile_parameters)
    parameters.merge(tracking_for_entity)
  end

  def user_parameters
    sensitive  = sensitive_parameters
    editable   = User.profile_parameters + sensitive
    parameters = params.require(:user).permit(editable)
    filter_parameters parameters, sensitive
  end

  def sensitive_parameters
    if current_user.authenticate params[:password].to_s
      User.sensitive_parameters
    else
      []
    end
  end

  def profile_parameters
    params.require(:user_profile).permit(UserProfile.entity_parameters)
  end

  def filter_parameters(parameters, sensitive)
    sensitive.each { |parameter| parameters.except! parameter if parameter.blank? }
    parameters[:email_confirmed] = false if parameters[:email] && parameters[:email] != current_user.email
    parameters[:phone_confirmed] = false if parameters[:phone] && parameters[:phone] != current_user.phone
    parameters
  end

  def redirect_after_creation
    return_path = cookies['return_path'].to_s
    return_path = my_profile_path unless return_path[0] == '/'
    cookies.delete 'return_path', domain: :all

    flash[:notice] = t('my.profiles.create.success')

    respond_to do |format|
      format.js { render(js: "document.location.href= '#{return_path}'") }
      format.html { redirect_to return_path }
    end
  end
end
