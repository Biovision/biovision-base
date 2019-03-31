# frozen_string_literal: true

# User
class User < ApplicationRecord
  include Checkable
  include Toggleable

  METRIC_REGISTRATION            = 'users.registration.hit'
  METRIC_AUTHENTICATION_SUCCESS  = 'users.authentication.success.hit'
  METRIC_AUTHENTICATION_FAILURE  = 'users.authentication.failure.hit'
  METRIC_AUTHENTICATION_EXTERNAL = 'users.authentication.external.hit'

  EMAIL_LIMIT  = 250
  NOTICE_LIMIT = 255
  PHONE_LIMIT  = 50
  SLUG_LIMIT   = 250

  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i.freeze

  SCREEN_NAME_LIMIT        = 30
  SCREEN_NAME_PATTERN      = /\A[-a-z0-9_]{1,30}\z/i.freeze
  SCREEN_NAME_PATTERN_HTML = '^[-a-zA-Z0-9_]{1,30}$'

  toggleable %i[allow_login email_confirmed phone_confirmed allow_mail]

  has_secure_password

  mount_uploader :image, AvatarUploader

  belongs_to :language, optional: true, counter_cache: true
  belongs_to :agent, optional: true
  belongs_to :inviter, class_name: User.to_s, optional: true
  has_many :invitees, class_name: User.to_s, foreign_key: :inviter_id, dependent: :nullify
  has_many :tokens, dependent: :delete_all
  has_many :codes, dependent: :delete_all
  has_many :user_privileges, dependent: :destroy
  has_many :privileges, through: :user_privileges
  has_many :foreign_users, dependent: :delete_all
  has_many :login_attempts, dependent: :delete_all
  has_many :user_languages, dependent: :delete_all

  after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }

  before_save { self.slug = (native_slug? ? screen_name : slug).downcase }
  before_save :prepare_search_string
  before_save { self.referral_link = SecureRandom.alphanumeric(12) if referral_link.blank? }

  before_validation { self.email = nil if email.blank? }

  validates_acceptance_of :consent
  validates_presence_of :screen_name
  validates_format_of :screen_name, with: SCREEN_NAME_PATTERN, if: :native_slug?
  validates_format_of :email, with: EMAIL_PATTERN, allow_blank: true
  validates :screen_name, uniqueness: { case_sensitive: false }
  validates :email, uniqueness: { case_sensitive: false }, allow_nil: true
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :screen_name, maximum: SLUG_LIMIT
  validates_length_of :email, maximum: EMAIL_LIMIT
  validates_length_of :phone, maximum: PHONE_LIMIT
  validates_length_of :notice, maximum: NOTICE_LIMIT

  scope :with_privilege, ->(privilege) { joins(:user_privileges).where(user_privileges: { privilege_id: privilege.branch_ids }) }
  scope :with_privilege_ids, ->(privilege_ids) { joins(:user_privileges).where(user_privileges: { privilege_id: privilege_ids }) }
  scope :ordered_by_screen_name, -> { order('screen_name asc') }
  scope :bots, ->(flag) { where(bot: flag.to_i.positive?) unless flag.blank? }
  scope :email_like, ->(v) { where('email ilike ?', "%#{v}%") unless v.blank? }
  scope :with_email, ->(v) { where('lower(email) = lower(?)', v) }
  scope :screen_name_like, ->(v) { where('screen_name ilike ?', "%#{v}%") unless v.blank? }
  scope :search, ->(q) { where('search_string like ?', "%#{q.downcase}%") unless q.blank? }
  scope :filtered, ->(f) { email_like(f[:email]).screen_name_like(f[:screen_name]) }
  scope :list_for_administration, -> { order('id desc') }
  scope :created_after, ->(v) { where('created_at >= ?', v) unless v.blank? }
  scope :created_before, ->(v) { where('created_at <= ?', v) unless v.blank? }

  # @param [Integer] page
  # @param [String] search_query
  def self.page_for_administration(page, search_query = '')
    list_for_administration.search(search_query).page(page)
  end

  def self.profile_parameters
    %i[image allow_mail birthday consent]
  end

  def self.sensitive_parameters
    %i[email phone password password_confirmation]
  end

  # Параметры при регистрации
  def self.new_profile_parameters
    profile_parameters + sensitive_parameters + %i[screen_name]
  end

  # Параметры для администрирования
  def self.entity_parameters
    flags = %i[bot allow_login email_confirmed phone_confirmed foreign_slug]

    new_profile_parameters + flags + %i[screen_name notice balance]
  end

  def self.ids_range
    min = User.minimum(:id).to_i
    max = User.maximum(:id).to_i
    (min..max)
  end

  # Name to be shown as profile
  #
  # This can be redefined for cases when something other than screen name should
  # be used.
  #
  # @return [String]
  def profile_name
    screen_name
  end

  def name_for_letter
    data.dig('profile', 'name').blank? ? profile_name : data['profile']['name']
  end

  # @param [Boolean] include_patronymic
  def full_name(include_patronymic = false)
    result = [name_for_letter]
    result << data.dig('profile', 'patronymic').to_s.strip if include_patronymic
    result << data.dig('profile', 'surname').to_s.strip
    result.compact.join(' ')
  end

  def can_receive_letters?
    allow_mail? && !email.blank?
  end

  def native_slug?
    !foreign_slug?
  end

  private

  def prepare_search_string
    string = "#{slug} #{email} #{UserProfileHandler.search_string(self)}"

    self.search_string = string.downcase
  end
end
