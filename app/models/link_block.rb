class LinkBlock < ApplicationRecord
  include Checkable
  include Toggleable

  toggleable :visible

  SLUG_LIMIT        = 50
  SLUG_PATTERN      = /\A[a-z][-_a-z0-9]*[a-z]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z][-_a-zA_Z0-9]*[a-zA-Z]$'
  TITLE_LIMIT       = 255
  TEXT_LIMIT        = 5000

  belongs_to :language, optional: true
  has_many :link_block_items, dependent: :destroy

  validates_uniqueness_of :slug, scope: [:language_id]
  validates_format_of :slug, with: SLUG_PATTERN
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :lead, maximum: TEXT_LIMIT
  validates_length_of :footer_text, maximum: TEXT_LIMIT

  scope :ordered_by_slug, -> { order('slug asc, language_id asc nulls first') }
  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, -> { ordered_by_slug }

  # @param [String] slug
  # @param [String] language_code
  def self.localized_block(slug, language_code)
    language = Language.find_by(code: language_code)
    criteria = { visible: true, slug: slug }
    find_by(criteria.merge(language: language)) || find_by(criteria)
  end

  def self.entity_parameters
    %i(footer_text language_id lead slug title visible)
  end
end
