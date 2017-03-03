class Code < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  enum category: [:confirmation, :recovery, :invitation]

  after_initialize :generate_body

  validates_presence_of :body
  validates_uniqueness_of :body

  scope :recent, -> { order('id desc') }
  scope :active, -> { where('quantity > 0') }
  scope :confirmations, -> { where(category: Code.categories[:confirmation]) }
  scope :recoveries, -> { where(category: Code.categories[:recovery]) }
  scope :invitations, -> { where(category: Code.categories[:invitation]) }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end

  # @param [String] body
  def self.active_invitation(body)
    invitations.active.find_by(body: body)
  end

  # @param [User] user
  def self.recovery_for_user(user)
    parameters = { user: user, category: categories[:recovery] }
    active.find_by(parameters) || create(parameters.merge(payload: user.email))
  end

  # @param [User] user
  def self.confirmation_for_user(user)
    parameters = { user: user, category: categories[:confirmation] }
    active.find_by(parameters) || create(parameters.merge(payload: user.email))
  end

  def self.entity_parameters
    %i(body payload quantity)
  end

  def self.creation_parameters
    entity_parameters + %i(user_id category)
  end

  def activated?
    quantity < 1
  end

  private

  def generate_body
    return unless body.nil?
    number    = SecureRandom.random_number(0xffff_ffff_ffff_ffff)
    self.body = number.to_s(36).scan(/.{4}/).join('-').upcase
  end
end
