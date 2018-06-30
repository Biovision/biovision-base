class User < ApplicationRecord
  include Toggleable

  METRIC_REGISTRATION            = 'users.registration.hit'
  METRIC_AUTHENTICATION_SUCCESS  = 'users.authentication.success.hit'
  METRIC_AUTHENTICATION_FAILURE  = 'users.authentication.failure.hit'
  METRIC_AUTHENTICATION_EXTERNAL = 'users.authentication.external.hit'

  PER_PAGE = 20

  SLUG_LIMIT   = 250
  EMAIL_LIMIT  = 250
  NOTICE_LIMIT = 255
  PHONE_LIMIT  = 50

  EMAIL_PATTERN            = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i
  SCREEN_NAME_LIMIT        = 30
  SCREEN_NAME_PATTERN      = /\A[a-z0-9_]{1,30}\z/i
  SCREEN_NAME_PATTERN_HTML = '^[a-zA-Z0-9_]{1,30}$'

  toggleable %i(allow_login bot email_confirmed phone_confirmed allow_mail)

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

  before_save :normalize_slug
  before_save :prepare_search_string

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
  scope :with_privilege_ids, -> (privilege_ids) { joins(:user_privileges).where(user_privileges: { privilege_id: privilege_ids }) }
  scope :ordered_by_screen_name, -> { order('screen_name asc') }
  scope :bots, ->(flag) { where(bot: flag.to_i > 0) unless flag.blank? }
  scope :email_like, ->(val) { where('email ilike ?', "%#{val}%") unless val.blank? }
  scope :with_email, ->(email) { where('lower(email) = lower(?)', email) }
  scope :screen_name_like, ->(val) { where('screen_name ilike ?', "%#{val}%") unless val.blank? }
  scope :search, ->(q) { where('search_string like ?', "%#{q.downcase}%") unless q.blank? }
  scope :filtered, ->(f) { email_like(f[:email]).screen_name_like(f[:screen_name]) }
  scope :list_for_administration, -> { order('id desc') }

  # @param [Integer] page
  # @param [String] search_query
  def self.page_for_administration(page, search_query = '')
    list_for_administration.search(search_query).page(page).per(PER_PAGE)
  end

  def self.profile_parameters
    %i(image allow_mail birthday consent)
  end

  def self.sensitive_parameters
    %i(email phone password password_confirmation)
  end

  # Параметры при регистрации
  def self.new_profile_parameters
    profile_parameters + sensitive_parameters + %i(screen_name)
  end

  # Параметры для администрирования
  def self.entity_parameters
    flags = %i(bot allow_login email_confirmed phone_confirmed foreign_slug)

    new_profile_parameters + flags + %i(screen_name notice balance)
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
    profile_data['name'].blank? ? profile_name : profile_data['name']
  end

  # @param [Boolean] include_patronymic
  def full_name(include_patronymic = false)
    result = [name_for_letter]
    result << profile_data['patronymic'].to_s.strip if include_patronymic
    result << profile_data['surname'].to_s.strip
    result.compact.join(' ')
  end

  def can_receive_letters?
    allow_mail? && !email.blank?
  end

  def native_slug?
    !foreign_slug?
  end

  private

  def normalize_slug
    self.slug = (native_slug? ? screen_name : slug).downcase
  end

  def prepare_search_string
    string = "#{slug} #{email} #{UserProfileHandler.search_string(self)}"

    self.search_string = string.downcase
  end
end
