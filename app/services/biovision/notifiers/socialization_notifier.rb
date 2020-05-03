# frozen_string_literal: true

module Biovision
  module Notifiers
    # Notification mapper for socialization component
    class SocializationNotifier < BaseNotifier
      TYPE_FOLLOWER = 'follower'
      TYPE_MESSAGE = 'message'

      def entity
        data = notification&.data.to_h
        case data['type']
        when TYPE_MESSAGE, TYPE_FOLLOWER
          User.find_by(id: data['id'])
        else
          nil
        end
      end

      # @param [Integer] sender_id
      def new_message(sender_id)
        check_and_notify(sender_id, TYPE_MESSAGE)
      end

      # @param [Integer] follower_id
      def new_follower(follower_id)
        check_and_notify(follower_id, TYPE_FOLLOWER)
      end
    end
  end
end
