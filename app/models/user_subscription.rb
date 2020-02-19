# frozen_string_literal: true

# User subscription (followers and followees)
#
# Attributes:
#   created_at [DateTime]
#   followee_id [User]
#   follower_id [User]
#   updated_at [DateTime]
class UserSubscription < ApplicationRecord
  belongs_to :follower, class_name: User.to_s
  belongs_to :followee, class_name: User.to_s

  validates_uniqueness_of :followee_id, scope: :follower_id

  after_create :follow_impact
  after_destroy :unfollow_impact

  scope :recent, -> { order('id desc') }
  scope :followers, ->(u) { where(followee: u).recent }
  scope :followees, ->(u) { where(follower: u).recent }

  private

  def follow_impact
    update_counter(follower, 'followee_count', 1)
    update_counter(followee, 'follower_count', 1)
  end

  def unfollow_impact
    update_counter(follower, 'followee_count', -1)
    update_counter(followee, 'follower_count', -1)
  end

  # @param [User] user
  # @param [String] counter
  # @param [Integer] delta
  def update_counter(user, counter, delta)
    return if user.nil?

    key = Biovision::Components::SocializationComponent.slug

    user.data[key] ||= {}
    new_value = user.data.dig(key, counter).to_i + delta
    user.data[key][counter] = new_value
    user.save
  end
end
