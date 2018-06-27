class EditableBlock < ApplicationRecord
  include Checkable
  include Toggleable

  NAME_LIMIT        = 50
  SLUG_LIMIT        = 50
  SLUG_PATTERN      = /\A[a-z][-_a-z0-9]*[a-z]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z][-_a-zA_Z0-9]*[a-zA-Z]$'
  TITLE_LIMIT       = 255
  TEXT_LIMIT        = 5000

  toggleable :visible

  mount_uploader :image, EditablePageImageUploader

  belongs_to :language, optional: true

  validates_presence_of :name
  validates_uniqueness_of :slug, scope: [:language_id]
  validates_format_of :slug, with: SLUG_PATTERN
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :lead, maximum: TEXT_LIMIT
  validates_length_of :body, maximum: TEXT_LIMIT
  validates_length_of :footer, maximum: TEXT_LIMIT

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
    %i(body footer image language_id lead name slug title visible)
  end

  # @param [User] user
  def editable_by?(user)
    UserPrivilege.user_has_privilege?(user, :content_manager)
  end
end
