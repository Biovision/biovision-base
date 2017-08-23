class StoredValue < ApplicationRecord
  include RequiredUniqueSlug

  SLUG_LIMIT = 50
  NAME_LIMIT = 100
  DESCRIPTION_LIMIT = 250
  VALUE_LIMIT = 255

  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_length_of :value, maximum: VALUE_LIMIT

  def self.page_for_administration
    ordered_by_slug
  end

  def self.entity_parameters
    %i(slug name description value)
  end

  # @param [String] slug
  # @param [String] default
  def self.receive(slug, default = '')
    entity = find_by(slug: slug)
    entity&.value || default
  end
end
