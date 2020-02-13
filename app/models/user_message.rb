# frozen_string_literal: true

# Message from user to user
# 
# Attributes:
#   agent_id [Agent], optional
#   body [text]
#   created_at [DateTime]
#   data [jsonb]
#   ip [inet]
#   read [boolean]
#   receiver_deleted [boolean]
#   receiver_id [integer]
#   sender_id [integer]
#   sender_deleted [boolean]
#   updated_at [DateTime]
#   uuid [uuid]
class UserMessage < ApplicationRecord
  include HasUuid

  BODY_LIMIT = 5000

  belongs_to :agent, optional: true
  belongs_to :sender, class_name: User.to_s
  belongs_to :receiver, class_name: User.to_s

  validates_presence_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  scope :recent, -> { order('id desc') }
  scope :unread, -> { where(read: false) }
  scope :sent_by, ->(v) { where(sender_id: v.id) }
  scope :received_by, ->(v) { where(receiver_id: v.id) }

  # @param [User] user
  def self.[](user)
    where('sender_id = ? or receiver_id = ?', user&.id, user&.id)
  end

  def self.entity_parameters
    %i[body]
  end

  # @param [User] user
  def sender?(user)
    sender == user
  end

  # @param [User] user
  def receiver?(user)
    receiver == user
  end
end
