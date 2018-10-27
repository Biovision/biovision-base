# frozen_string_literal: true

# Code type
#
# Attributes:
#   - name [String]
#   - slug [String]
class CodeType < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug

  SLUG_LIMIT = 20
  NAME_LIMIT = 100

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT

  has_many :codes, dependent: :delete_all
end
