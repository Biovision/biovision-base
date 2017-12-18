class FeedbackRequest < ApplicationRecord
  include Toggleable

  NAME_LIMIT    = 100
  EMAIL_LIMIT   = 250
  PHONE_LIMIT   = 30
  COMMENT_LIMIT = 5000
  PER_PAGE      = 20

  toggleable :processed

  belongs_to :agent, optional: true

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :phone, maximum: PHONE_LIMIT
  validates_length_of :comment, maximum: COMMENT_LIMIT
  validates_length_of :email, maximum: EMAIL_LIMIT
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i, allow_blank: true

  scope :recent, -> { order('id desc') }
  scope :unprocessed, -> { where(processed: false) }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end

  def self.creation_parameters
    %i(name email phone comment)
  end
end
