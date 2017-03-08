class My::RecoveriesController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user
  before_action :find_user, only: [:create, :update]

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
    find_code
    if @code.nil?
      redirect_to my_recovery_path, alert: t('my.recoveries.update.invalid_code')
    else
      reset_password
    end
  end

  protected

  def find_user
    @user = User.find_by slug: params[:login].to_s.downcase, network: User.networks[:native]
  end

  def find_code
    @code = Code.active.find_by user: @user, category: Code.categories[:recovery]
  end

  def send_code
    code = Code.recovery_for_user @user
    if code.nil?
      logger.warn { "Could not get recovery code for user #{@user.id}" }
    else
      CodeSender.password(code).deliver_now
    end
  end

  def reset_password
    if @user.update new_user_parameters
      create_token_for_user @user, tracking_for_entity
      @code.decrement! :quantity
      redirect_to root_path, notice: t('my.recoveries.update.success')
    else
      render :show, status: :bad_request
    end
  end

  def new_user_parameters
    parameters = params.require(:user).permit(:password)
    parameters[:password] = nil if parameters[:password].blank?
    parameters[:email_confirmed] = true if @code.payload == @user.email
    parameters
  end
end
