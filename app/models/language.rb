# frozen_string_literal: true

# Language
#
# Attributes:
#   active [Boolean]
#   code [String]
#   created_at [DateTime]
#   priority [Integer]
#   slug [String]
#   updated_at [DateTime]
#   users_count [Integer]
class Language < ApplicationRecord
  include FlatPriority

  SLUG_LIMIT = 20
  CODE_LIMIT = 8

  validates_presence_of :code, :slug
  validates_format_of :code, with: /\A[a-z][a-z_]*[a-z]\z/i
  validates_format_of :slug, with: /\A[a-z][a-z_]+[a-z]\z/
  validates_length_of :code, maximum: CODE_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_uniqueness_of :code
  validates_uniqueness_of :slug

  scope :active, -> { where(active: true) }

  # @param [String|Symbol] code
  def self.[](code)
    find_by(code: code)
  end
end
