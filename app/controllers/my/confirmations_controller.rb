class My::ConfirmationsController < ApplicationController
  before_action :restrict_anonymous_access, only: [:create, :update]
  before_action :redirect_confirmed_user, only: [:create, :update]

  # get /my/confirmation
  def show
  end

  # post /my/confirmation
  def create
    if current_user.email.blank?
      redirect_to edit_my_profile_path, notice: t('my.confirmations.create.set_email')
    else
      code = Code.confirmation_for_user current_user
      CodeSender.email(code).deliver_now unless code.nil?
      redirect_to my_confirmation_path, notice: t('my.confirmations.create.success')
    end
  end

  # patch /my/confirmation
  def update
    @code = Code.active.find_by category: Code.categories[:confirmation], body: params[:code].to_s
    if @code.is_a?(Code) && @code.owned_by?(current_user)
      activate_code
      redirect_to root_path
    else
      redirect_to my_confirmation_path, alert: t('my.confirmations.update.invalid_code')
    end
  end

  protected

  def redirect_confirmed_user
    redirect_to my_confirmation_path, notice: t(:email_already_confirmed) if current_user.email_confirmed?
  end

  def activate_code
    @code.decrement! :quantity
    @code.user.update email_confirmed: true if @code.payload == @code.user.email
  end
end
