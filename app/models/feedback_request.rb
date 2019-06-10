# frozen_string_literal: true

# Feedback request
#
# Attributes:
#   agent_id [Agent], optional
#   comment [text]
#   consent [boolean]
#   created_at [DateTime]
#   data [jsonb]
#   email [string], optional
#   image [string], optional
#   ip [inet], optional
#   language_id [Language], optional
#   name [string], optional
#   phone [string], optional
#   processed [boolean]
#   updated_at [DateTime]
#   user_id [User], optional
class FeedbackRequest < ApplicationRecord
  include Toggleable

  COMMENT_LIMIT = 5000
  EMAIL_LIMIT   = 250
  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i.freeze
  NAME_LIMIT    = 100
  PHONE_LIMIT   = 30

  toggleable :processed

  belongs_to :language, optional: true
  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  validates_acceptance_of :consent
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :phone, maximum: PHONE_LIMIT
  validates_length_of :comment, maximum: COMMENT_LIMIT
  validates_length_of :email, maximum: EMAIL_LIMIT
  validates_format_of :email, with: EMAIL_PATTERN, allow_blank: true

  scope :recent, -> { order('id desc') }
  scope :unprocessed, -> { where(processed: false) }
  scope :list_for_administration, -> { recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.creation_parameters
    %i[comment consent email name phone]
  end
end
