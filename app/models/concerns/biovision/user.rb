module Biovision::User
  extend ActiveSupport::Concern

  included do
    include Toggleable

    toggleable %i(allow_login bot email_confirmed phone_confirmed allow_mail)

    belongs_to :agent, optional: true

    has_secure_password

    mount_uploader :image, AvatarUploader

    belongs_to :agent, optional: true
    belongs_to :inviter, class_name: User.to_s, optional: true
    has_many :invitees, class_name: User.to_s, foreign_key: :inviter_id, dependent: :nullify
    has_many :tokens, dependent: :delete_all
    has_many :codes, dependent: :delete_all
    has_many :user_privileges, dependent: :destroy
    has_many :privileges, through: :user_privileges

    before_save { self.slug = screen_name.downcase unless screen_name.nil? }

    validates_presence_of :screen_name, :email
    validates_format_of :screen_name, with: /\A[a-z0-9_]{1,30}\z/i
    validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i
    validates :screen_name, uniqueness: { case_sensitive: false }
    validates :email, uniqueness: { case_sensitive: false }
  end

  module ClassMethods

  end
end
