# frozen_string_literal: true

# Personal ban for user
#
# Attributes:
#   created_at [DateTime]
#   other_user_id [User]
#   updated_at [DateTime]
#   user_id [User]
class UserBan < ApplicationRecord
  include HasOwner

  belongs_to :user
  belongs_to :other_user, class_name: User.to_s

  validates_uniqueness_of :other_user_id, scope: :user_id

  # @param [User] user
  def self.[](user)
    owned_by(user)
  end
end
