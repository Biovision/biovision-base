# frozen_string_literal: true

# Code for user
#
# Attributes:
#   - agent_id [Agent], optional
#   - body [String]
#   - code_type_id [CodeType]
#   - ip [Inet]
#   - payload [String], optional
#   - quantity [Integer]
#   - user_id [User], optional
class Code < ApplicationRecord
  include HasOwner

  BODY_LIMIT     = 50
  PAYLOAD_LIMIT  = 250
  QUANTITY_RANGE = (0..32_767)

  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  belongs_to :code_type

  after_initialize :generate_body

  before_validation :sanitize_quantity

  validates_presence_of :body
  validates_uniqueness_of :body
  validates_length_of :body, maximum: BODY_LIMIT
  validates_length_of :payload, maximum: PAYLOAD_LIMIT

  scope :recent, -> { order('id desc') }
  scope :active, -> { where('quantity > 0') }
  scope :list_for_administration, -> { recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[body payload quantity]
  end

  def self.creation_parameters
    entity_parameters + %i[user_id code_type_id]
  end

  def activated?
    quantity < 1
  end

  def active?
    quantity.positive?
  end

  private

  def generate_body
    return unless body.nil?

    number    = SecureRandom.random_number(0xffff_ffff_ffff_ffff)
    self.body = number.to_s(36).scan(/.{4}/).join('-').upcase
  end

  def sanitize_quantity
    self.quantity = QUANTITY_RANGE.first if quantity < QUANTITY_RANGE.first
    self.quantity = QUANTITY_RANGE.last if quantity > QUANTITY_RANGE.last
  end
end
