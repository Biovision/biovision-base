class Token < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE = 25

  toggleable :active

  has_secure_token

  belongs_to :user
  belongs_to :agent, optional: true

  validates_uniqueness_of :token

  scope :recent, -> { order('last_used desc nulls last') }
  scope :active, ->(flag) { where(active: flag.to_i > 0) unless flag.blank? }
  scope :filtered, ->(f) { with_user_id(f[:user_id]).active(f[:active]) }

  # @param [Integer] page
  def self.page_for_administration(page, filter = {})
    filtered(filter).recent.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page)
    owned_by(user).recent.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(active)
  end

  def self.creation_parameters
    entity_parameters + %i(user_id)
  end

  # @param [String] input
  # @param [Boolean] touch_user
  def self.user_by_token(input, touch_user = false)
    return if input.blank?
    pair = input.split(':')
    user_by_pair(pair[0], pair[1], touch_user)
  end

  # @param [Integer] user_id
  # @param [String] token
  # @param [Boolean] touch_user
  def self.user_by_pair(user_id, token, touch_user = false)
    instance = find_by(user_id: user_id, token: token, active: true)
    return if instance.nil?
    instance.update_columns(last_used: Time.now)
    instance.user.update_columns(last_seen: Time.now) if touch_user
    instance.user
  end

  def name
    "[#{id}] #{user.profile_name}"
  end

  # @param [User] user
  def editable_by?(user)
    owned_by?(user) || UserPrivilege.user_has_privilege?(user, :administrator)
  end

  def cookie_pair
    "#{user_id}:#{token}"
  end
end
