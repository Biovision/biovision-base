# frozen_string_literal: true

# Biovision component
#
# Attributes:
#   created_at [DateTime]
#   parameters [JSON]
#   priority [Integer]
#   settings [JSON]
#   slug [String]
#   updated_at [DateTime]
class BiovisionComponent < ApplicationRecord
  include RequiredUniqueSlug
  include FlatPriority

  SLUG_LIMIT        = 250
  SLUG_PATTERN      = /\A[a-z][-a-z0-9_]+[a-z0-9]\z/i.freeze
  SLUG_PATTERN_HTML = '^[a-zA-Z][-a-zA-Z0-9_]+[a-zA-Z0-9]$'
  VALUE_LIMIT       = 65_535

  has_many :biovision_component_users, dependent: :delete_all

  scope :list_for_administration, -> { ordered_by_priority }

  # Find component by slug
  #
  # @param [String] slug
  def self.[](slug)
    find_by(slug: slug)
  end

  # @param [String] slug
  # @param [String] default_value
  def get(slug, default_value = '')
    parameters.fetch(slug.to_s) { default_value }
  end

  # @param [String] slug
  # @deprecated use #get
  def receive(slug)
    parameters[slug.to_s]
  end

  # @param [String] slug
  # @param [String] default_value
  # @deprecated use #get
  def receive!(slug, default_value = '')
    get(slug, default_value)
  end

  # @param [String] slug
  # @param value
  def []=(slug, value)
    parameters[slug.to_s] = value
    save!
  end

  # @param [User] user
  def visible_to?(user)
    return false if user.nil?
    return true if user.super_user?

    biovision_component_users.where(user: user).exists?
  end

  def name
    I18n.t("biovision.components.#{slug}.name", default: slug)
  end
end
