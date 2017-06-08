class ForeignSite < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug

  has_many :foreign_users, dependent: :delete_all

  def self.page_for_administration
    ordered_by_name
  end

  # @param [Hash] data
  # @param [Hash] tracking
  def authenticate(data, tracking)
    user = foreign_users.find_by(slug: data[:uid])&.user
    user || create_user(data, tracking)
  end

  private

  # @param [Hash] data
  # @param [Hash] tracking
  # @return [User]
  def create_user(data, tracking)
    parameters = {
      user: native_user(data, tracking),
      slug: data[:uid],
      name: data[:info][:name],
      email: data[:info][:email],
      data: JSON.generate(data.dig(:extra, :raw_info))
    }.merge(tracking)
    foreign_users.create!(parameters).user
  end

  # @param [Hash] data
  # @param [Hash] tracking
  # @return [User]
  def native_user(data, tracking)
    user  = nil
    email = data.dig(:info, :email)
    unless email.blank?
      user = User.with_email(email).first
    end
    user || create_native_user(data, tracking)
  end

  # @param [Hash] data
  # @param [Hash] tracking
  # @return [User]
  def create_native_user(data, tracking)
    screen_name = data.dig(:info, :nickname)
    image_url   = data.dig(:info, :image)
    password    = SecureRandom.urlsafe_base64(12)
    hash_salt   = BCrypt::Engine.generate_salt
    parameters  = {
      foreign_slug: true,
      slug: "#{slug}-#{data[:uid]}",
      email: data[:info][:email],
      name: data[:info][:first_name],
      surname: data[:info][:last_name],
      screen_name: screen_name.blank? ? data[:name] : screen_name,
      password_digest: BCrypt::Engine.hash_secret(password, hash_salt),
      email_confirmed: true,
    }.merge(tracking)

    parameters[:remote_image_url] = data[:info][:image] unless image_url.blank?

    User.create!(parameters)
  end
end