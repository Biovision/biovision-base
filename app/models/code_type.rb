class CodeType < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug

  SLUG_LIMIT = 20
  NAME_LIMIT = 100

  validates_length_of :name, maximum: NAME_LIMIT

  has_many :codes, dependent: :delete_all
end
