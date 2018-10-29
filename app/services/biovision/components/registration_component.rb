# frozen_string_literal: true

module Biovision
  module Components
    # Handler for registration component
    class RegistrationComponent < BaseComponent
      # @param [Hash] parameters
      # @param [Code] code
      def handle(parameters, code)
        @user    = User.new(parameters)
        @manager = CodeManager::Invitation.new(code)

        use_invites? ? use_code : persist_user

        @user
      end

      def open?
        @component.settings['open']
      end

      def invite_only?
        @component.settings['invite_only']
      end

      def use_invites?
        @component.settings['use_invites'] || invite_only?
      end

      def confirm_email?
        @component.settings['confirm_email']
      end

      def require_email?
        @component.settings['require_email']
      end

      protected

      # @param [Hash] data
      # @return [Hash]
      def normalize_settings(data)
        result = {}
        flags  = %w[open invite_only use_invites confirm_email require_email]
        flags.each { |f| result[f] = data[f].to_i == 1 }
        numbers = %w[invite_count]
        numbers.each { |f| result[f] = data[f].to_i }

        result
      end

      def persist_user
        return unless @user.save

        Metric.register(User::METRIC_REGISTRATION)

        handle_codes
      end

      # Check invitation code and persist user if it's valid
      def use_code
        if @manager.code_is_valid? || (@manager.code.nil? && !invite_only?)
          persist_user
        else
          error = I18n.t('biovision.components.registration.invalid_code')

          # Add "invalid code" error to other model errors, if any
          @user.valid?
          @user.errors.add(:code, error)
        end
      end

      def handle_codes
        if confirm_email?
          code = CodeManager::Confirmation.code_for_user(@user)
          CodeSender.confirmation(code.id).deliver_later
        end

        if use_invites?
          @manager.activate(@user) if @manager.code_is_valid?
          create_invitations(settings['invite_count'].to_i)
        end
      end

      # @param [Integer] quantity
      def create_invitations(quantity = 1)
        return unless quantity.positive?

        parameters = {
          code_type: CodeManager::Invitation.code_type,
          user:      @user,
          quantity:  quantity,
        }
        Code.create(parameters)
      end
    end
  end
end
