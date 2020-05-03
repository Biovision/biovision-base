# frozen_string_literal: true

module Biovision
  module Notifiers
    # Base notifier class for dispatching component notifications
    class BaseNotifier
      attr_accessor :notification, :user

      # @param [User] user
      def initialize(user)
        @user = user
      end

      # @param [Notification] notification
      def self.[](notification)
        slug = notification.component_slug
        instance = handler_class(slug).new(notification.user)
        instance.notification = notification
        instance
      end

      def self.slug
        to_s.demodulize.underscore.gsub('_notifier', '')
      end

      # @param [String] slug
      def self.handler_class(slug)
        handler_name = "biovision/notifiers/#{slug}_notifier".classify
        handler_name.safe_constantize || BaseNotifier
      end

      def component
        @component ||= BiovisionComponent[self.class.slug]
      end

      def entity
        nil
      end

      def view
        return if notification.nil?

        "my/notifications/#{self.class.slug}/#{notification.data['type']}"
      end

      # @param [Hash] data
      def notify(data)
        attributes = { user: user, biovision_component: component, data: data }
        Notification.create(attributes)
      end

      protected

      # @param [Integer] id
      # @param [String] type
      def check_and_notify(id, type)
        return if check_chain(id, type).exists?

        notify({id: id, type: type})
      end

      # @param [Integer] id
      # @param [String] type
      def check_chain(id, type)
        Notification.owned_by(user).unread.data_id(id).data_type(type)
      end
    end
  end
end
