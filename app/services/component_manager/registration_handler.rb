# frozen_string_literal: true

# Handler for registration component
class ComponentManager::RegistrationHandler < ComponentManager
  def open?
    @entity.settings['open']
  end

  def invite_only?
    @entity.settings['invite_only']
  end

  def confirm_email?
    @entity.settings['confirm_email']
  end

  protected

  # @param [Hash] new_settings
  # @return [Hash]
  def normalize_settings(new_settings)
    {
      open:          new_settings['open'].to_i == 1,
      invite_only:   new_settings['invite_only'].to_i == 1,
      confirm_email: new_settings['confirm_email'].to_i == 1
    }
  end
end
