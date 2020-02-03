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
        unban(followee)
      end

      # @param [User] followee
      def unfollow(followee)
        UserSubscription.where(follower: user, followee: followee).destroy_all
      end

      protected

      # @param [Hash] data
      def normalize_settings(data)
        result = {}
        flags = %w[messages subscriptions bans]
        flags.each { |f| result[f] = data[f].to_i == 1 }

        result
      end
    end
  end
end
