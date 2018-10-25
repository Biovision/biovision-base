# frozen_string_literal: true

# Biovision component parameter
#
# Fields:
#   - biovision_component_id [BiovisionComponent]
#   - deletable [Boolean]
#   - description [String], optional
#   - name [String], optional
#   - slug [String]
#   - value [String], optional
class BiovisionParameter < ApplicationRecord
  DESCRIPTION_LIMIT = 250
  NAME_LIMIT        = 250
  SLUG_LIMIT        = 250
  SLUG_PATTERN      = /\A[a-z][-a-z0-9_]+[a-z0-9]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z][-a-zA-Z0-9_]+[a-zA-Z0-9]$'
  VALUE_LIMIT       = 65_535

  belongs_to :biovision_component

  before_validation { self.slug = slug.to_s.strip.downcase }

  validates_uniqueness_of :slug, scope: [:biovision_component_id]
  validates_presence_of :slug
  validates_format_of :slug, with: SLUG_PATTERN
  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :value, maximum: VALUE_LIMIT

  scope :ordered_by_slug, -> { order('slug asc') }
  scope :list_for_administration, -> { ordered_by_slug }

  def self.entity_parameters
    %i[description name slug value]
  end
end
