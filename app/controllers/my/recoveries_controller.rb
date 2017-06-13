class My::RecoveriesController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user
  before_action :find_user, only: [:create]

  # get /my/recovery
  def show
  end

  # post /my/recovery
  def create
    if @user.nil? || @user.email.blank?
      redirect_to my_recovery_path, alert: t('my.recoveries.create.impossible')
    else
      send_code
      redirect_to my_recovery_path, notice: t('my.recoveries.create.completed')
    end
  end

  # patch /my/recovery
  def update
    set_manager
    if @manager.code_is_valid?
      reset_password
    else
      redirect_to my_recovery_path, alert: t('my.recoveries.update.invalid_code')
    end
  end

  protected

  def find_user
    @user = User.with_email(param_from_request(:email)).first
  end

  def set_manager
    code     = Code.find_by(body: param_from_request(:code))
    @manager = CodeManager::Recovery.new(code)
  end

  def send_code
    code = CodeManager::Recovery.code_for_user(@user)
    if code.nil?
      logger.warn { "Could not get recovery code for user #{@user.id}" }
    else
      CodeSender.password(code.id).deliver_later
    end
  end

  def reset_password
    if @manager.activate(new_user_parameters)
      create_token_for_user @manager.code.user
      redirect_to my_path, notice: t('my.recoveries.update.success')
    else
      render :show, status: :bad_request
    end
  end

  def new_user_parameters
    parameters = params.require(:user).permit(:password, :password_confirmation)
    if parameters[:password].blank?
      parameters[:password]              = nil
      parameters[:password_confirmation] = nil
    end
    parameters
  end
end
