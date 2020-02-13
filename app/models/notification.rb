# frozen_string_literal: true

# Component notification for user
# 
# Attributes:
#   biovision_component_id [BiovisionComponent]
#   created_at [DateTime]
#   data [jsonb]
#   email_sent [boolean]
#   read [boolean]
#   updated_at [DateTime]
#   user_id [User]
#   uuid [uuid]
class Notification < ApplicationRecord
  include HasOwner
  include HasUuid

  belongs_to :biovision_component
  belongs_to :user

  scope :recent, -> { order('id desc') }
  scope :unread, -> { where(read: false) }
  scope :not_sent, -> { where(email_sent: false) }
  scope :data_id, ->(v) { where("cast(data->>'id' as integer) = ?", v) }
  scope :data_type, ->(v) { where("data->>'type' = ?", v) }
  scope :list_for_owner, ->(v) { owned_by(v).recent }

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page = 1)
    list_for_owner(user).page(page)
  end

  def component_slug
    biovision_component.slug
  end
end
