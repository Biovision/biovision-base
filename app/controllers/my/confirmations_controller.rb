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
      code = CodeManager::Confirmation.code_for_user(current_user)
      CodeSender.email(code.id).deliver_later unless code.nil?
      redirect_to my_confirmation_path, notice: t('my.confirmations.create.success')
    end
  end

  # patch /my/confirmation
  def update
    code    = Code.find_by(body: param_from_request(:code))
    manager = CodeManager::Confirmation.new(code, current_user)
    if manager.code_is_valid?
      manager.activate
      redirect_to my_path
    else
      redirect_to my_confirmation_path, alert: t('my.confirmations.update.invalid_code')
    end
  end

  protected

  def redirect_confirmed_user
    redirect_to my_confirmation_path, notice: t(:email_already_confirmed) if current_user.email_confirmed?
  end
end
