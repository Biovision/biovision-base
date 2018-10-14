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
  VALUE_LIMIT       = 65_535

  belongs_to :biovision_component

  validates_uniqueness_of :slug, scope: [:biovision_component_id]
  validates_presence_of :slug
  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :value, maximum: VALUE_LIMIT

  scope :ordered_by_slug, -> { order('slug asc') }
  scope :list_for_administration, -> { ordered_by_slug }

  def self.entity_parameters
    %i[description name slug value]
  end

  # @param [String] slug
  # @param [String] default
  def self.receive(slug, default = '')
    entity = find_by(slug: slug)
    entity&.value || default
  end
end
