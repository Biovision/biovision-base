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

  scope :unread, -> { where(read: false) }
end
