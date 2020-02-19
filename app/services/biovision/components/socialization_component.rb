# frozen_string_literal: true

module Biovision
  module Components
    # Socialization of users
    class SocializationComponent < BaseComponent
      # @param [User] other_user
      def banned?(other_user)
        UserBan.owned_by(user).where(other_user: other_user).exists?
      end

      # @param [User] other_user
      def ban(other_user)
        UserBan.owned_by(user).create(other_user: other_user)
        unfollow(other_user)
      end

      # @param [User] other_user
      def unban(other_user)
        UserBan.owned_by(user).where(other_user: other_user).destroy_all
      end

      # @param [User] followee
      def follows?(followee)
        UserSubscription.where(follower: user, followee: followee).exists?
      end

      # @param [User] followee
      def follow(followee)
        UserSubscription.create(follower: user, followee: followee)
        notifier(followee).new_follower(user.id)

        unban(followee)
      end

      # @param [User] followee
      def unfollow(followee)
        UserSubscription.where(follower: user, followee: followee).destroy_all
      end

      def interlocutors
        ids = UserMessage[user].pluck(:sender_id, :receiver_id)
        User.where(id: ids.flatten.uniq - [user.id])
      end

      # @param [User] other_user
      # @param [Integer] page
      def messages(other_user, page = 1)
        id1 = user.id
        id2 = other_user.id
        clauses = [
          "(sender_id = #{id1} and receiver_id = #{id2})",
          "(sender_id = #{id2} and receiver_id = #{id1})"
        ]
        criteria = clauses.join(' or ')
        UserMessage.where(criteria).recent.page(page)
      end

      protected

      # @param [Hash] data
      def normalize_settings(data)
        result = {}
        flags = %w[messages subscriptions bans]
        flags.each { |f| result[f] = data[f].to_i == 1 }

        result
      end

      # @param [User] user
      def notifier(user)
        Biovision::Notifiers::SocializationNotifier.new(user)
      end
    end
  end
end
