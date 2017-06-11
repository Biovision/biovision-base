class Code < ApplicationRecord
  include HasOwner

  PER_PAGE       = 20
  BODY_LIMIT     = 50
  PAYLOAD_LIMIT  = 250
  QUANTITY_RANGE = (0..32767)

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

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(body payload quantity)
  end

  def self.creation_parameters
    entity_parameters + %i(user_id code_type_id)
  end

  def activated?
    quantity < 1
  end

  def active?
    quantity > 0
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
