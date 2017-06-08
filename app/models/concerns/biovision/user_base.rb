module Biovision::UserBase
  extend ActiveSupport::Concern

  included do
    include Toggleable

    METRIC_REGISTRATION            = 'users.registration.hit'
    METRIC_AUTHENTICATION_SUCCESS  = 'users.authentication.success.hit'
    METRIC_AUTHENTICATION_FAILURE  = 'users.authentication.failure.hit'
    METRIC_AUTHENTICATION_EXTERNAL = 'users.authentication.external.hit'

    PER_PAGE = 20

    toggleable %i(allow_login bot email_confirmed phone_confirmed allow_mail)

    belongs_to :agent, optional: true

    has_secure_password

    mount_uploader :image, AvatarUploader

    enum gender: [:female, :male]

    belongs_to :agent, optional: true
    belongs_to :inviter, class_name: User.to_s, optional: true
    has_many :invitees, class_name: User.to_s, foreign_key: :inviter_id, dependent: :nullify
    has_many :tokens, dependent: :delete_all
    has_many :codes, dependent: :delete_all
    has_many :user_privileges, dependent: :destroy
    has_many :privileges, through: :user_privileges
    has_many :foreign_users, dependent: :delete_all

    before_save :normalize_slug

    validates_presence_of :screen_name, :email
    validates_format_of :screen_name, with: /\A[a-z0-9_]{1,30}\z/i, if: :native_slug?
    validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i
    validates :screen_name, uniqueness: { case_sensitive: false }
    validates :email, uniqueness: { case_sensitive: false }

    scope :with_privilege, ->(privilege) { joins(:user_privileges).where(user_privileges: { privilege_id: privilege.ids }) }
    scope :bots, ->(flag) { where(bot: flag.to_i > 0) unless flag.blank? }
    scope :name_like, ->(val) { where('name ilike ?', "%#{val}%") unless val.blank? }
    scope :email_like, ->(val) { where('email ilike ?', "%#{val}%") unless val.blank? }
    scope :with_email, ->(email) { where('lower(email) = lower(?)', email) }
    scope :screen_name_like, ->(val) { where('screen_name ilike ?', "%#{val}%") unless val.blank? }
    scope :search, ->(q) { where("lower(concat_ws(' ', slug, email, surname, name)) like ?", "%#{q.downcase}%") unless q.blank? }
    scope :filtered, ->(f) { name_like(f[:name]).email_like(f[:email]).screen_name_like(f[:screen_name]) }
  end

  module ClassMethods
    # @param [Integer] page
    # @param [Hash] filter
    def page_for_administration(page, filter = {})
      bots(filter[:bots]).filtered(filter).order('slug asc').page(page).per(PER_PAGE)
    end

    def profile_parameters
      %i(image name patronymic surname birthday gender allow_mail)
    end

    def sensitive_parameters
      %i(email phone password password_confirmation)
    end

    # Параметры при регистрации
    def new_profile_parameters
      profile_parameters + sensitive_parameters + %i(screen_name)
    end

    # Параметры для администрирования
    def entity_parameters
      flags = %i(bot allow_login email_confirmed phone_confirmed foreign_slug)

      new_profile_parameters + flags + %i(screen_name notice)
    end
  end

  def profile_name
    screen_name
  end

  def name_for_letter
    name || profile_name
  end

  def can_receive_letters?
    allow_mail? && !email.blank?
  end

  def native_slug?
    !foreign_slug?
  end

  private

  def normalize_slug
    if native_slug?
      self.slug = screen_name.downcase
    else
      self.slug = slug.downcase
    end
  end
end
