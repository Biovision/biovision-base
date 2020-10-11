# frozen_string_literal: true

# Model for simple editable block
#
# Attributes:
#   background_image [Boolean]
#   body [Text], optional
#   created_at [DateTime]
#   image [SimpleImageUploader], optional
#   image_alt_text [String], optional
#   name [String]
#   slug [String]
#   updated_at [DateTime]
#   visible [Boolean]
class SimpleBlock < ApplicationRecord
  include Checkable
  include RequiredUniqueSlug
  include RequiredUniqueName
  include Toggleable

  BODY_LIMIT = 65_535
  META_LIMIT = 255
  NAME_LIMIT = 100
  SLUG_LIMIT = 30
  SLUG_PATTERN = /\A[a-z][-_a-z0-9]*[a-z0-9]\z/.freeze
  SLUG_PATTERN_HTML = '^[a-zA-Z][-_a-zA-Z0-9]*[a-zA-Z0-9]$'

  toggleable :visible, :background_image

  mount_uploader :image, SimpleImageUploader

  before_validation { self.slug = slug.to_s.downcase }

  validates_length_of :body, maximum: BODY_LIMIT
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN

  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, -> { ordered_by_slug }

  def self.entity_parameters
    %i[body image image_alt_text name slug] + toggleable_attributes
  end

  # @param [String] slug
  def self.partial(slug)
    for_visitors(slug) || 'simple_blocks/empty'
  end

  # @param [String] slug
  def self.for_visitors(slug)
    visible.find_by(slug: slug)
  end

  # Get body of visible block with given slug or empty string
  #
  # Can be used in views for quick output
  #
  # @param [String] slug
  # @return [String]
  def self.[](slug)
    SimpleBlock.visible.find_by(slug: slug)&.body.to_s
  end

  def text_for_link
    slug
  end
end
