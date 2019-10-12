# frozen_string_literal: true

# Editable page for site
#
# Attributes:
#   body [String]
#   image [EditablePageImageUploader], optional
#   image_alt_text [String], optional
#   language_id [Language]
#   meta_description [String], optional
#   meta_keywords [String], optional
#   meta_title [String], optional
#   name [String]
#   nav_group [String], optional
#   priority [Integer]
#   slug [String]
#   url [String], optional
#   visible [Boolean]
class EditablePage < ApplicationRecord
  include RequiredUniqueName
  include FlatPriority
  include MetaTexts
  include Checkable
  include Toggleable

  BODY_LIMIT = 16_777_215
  META_LIMIT = 255
  NAME_LIMIT = 100
  SLUG_LIMIT = 100

  toggleable :visible

  mount_uploader :image, SimpleImageUploader

  belongs_to :language, optional: true

  before_validation { self.slug = slug.strip unless slug.nil? }

  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: :language_id
  validates_length_of :body, maximum: BODY_LIMIT
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :url, maximum: META_LIMIT

  scope :ordered_by_slug, -> { order('slug asc') }
  scope :visible, -> { where(visible: true) }
  scope :with_slug_like, ->(v) { where('slug ilike ?', "%#{v}%") unless v.blank? }
  scope :with_slug, ->(v) { where(slug: v) unless v.blank? }
  scope :for_group, ->(v) { where(nav_group: v) }
  scope :for_language, ->(v) { where(language: v) }
  scope :siblings, ->(s) { where(language: s.language, nav_group: s.nav_group) }
  scope :list_for_administration, -> { ordered_by_priority }
  scope :list_for_visitors, -> { visible.ordered_by_priority }

  def self.page_for_administration
    ordered_by_slug
  end

  def self.entity_parameters
    data = %i[body image image_alt_text language_id name nav_group slug url]
    data + meta_text_fields
  end

  # @param [String] slug
  # @param [String] language_code
  # @deprecated use #localized_page
  def self.find_localized(slug, language_code)
    localized_page(slug, language_code)
  end

  # @param [String] slug
  # @param [String] language_code
  def self.localized_page(slug, language_code)
    language = Language.find_by(code: language_code)
    find_by(slug: slug, language: language) || find_by(slug: slug)
  end

  # @param [String] url
  # @param [String] language_code
  def self.fallback_page(url, language_code)
    language = Language.find_by(code: language_code)
    find_by(url: url, language: language) || find_by(url: url)
  end

  # @deprecated use #meta_title
  def title
    name
  end

  def text
    body
  end

  # @deprecated use #meta_keywords
  def keywords
    meta_keywords
  end

  # @deprecated use #meta_description
  def description
    meta_description
  end

  # @param [User] user
  def editable_by?(user)
    UserPrivilege.user_has_privilege?(user, :content_manager)
  end
end
