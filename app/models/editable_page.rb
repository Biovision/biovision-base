class EditablePage < ApplicationRecord
  include RequiredUniqueName

  NAME_LIMIT = 100
  SLUG_LIMIT = 100
  META_LIMIT = 250
  BODY_LIMIT = 65535

  PRIORITY_RANGE = (1..999)

  mount_uploader :image, EditablePageImageUploader

  belongs_to :language, optional: true

  after_initialize :set_next_priority
  before_validation { self.slug = slug.strip unless slug.nil? }
  before_validation :normalize_priority

  validates_presence_of :slug
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :title, maximum: META_LIMIT
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :keywords, maximum: META_LIMIT
  validates_length_of :description, maximum: META_LIMIT
  validates_length_of :body, maximum: BODY_LIMIT
  validates_uniqueness_of :slug, scope: [:language_id]

  scope :ordered_by_priority, -> { order('priority asc, slug asc') }
  scope :ordered_by_slug, -> { order('slug asc') }
  scope :with_slug_like, ->(slug) { where('slug ilike ?', "%#{slug}%") unless slug.blank? }
  scope :with_slug, ->(slug) { where('lower(slug) = lower(?)', slug) unless slug.blank? }
  scope :siblings, ->(s) { where(language: s.language, nav_group: s.nav_group) }
  scope :list_for_administration, -> { ordered_by_priority }

  def self.page_for_administration
    ordered_by_slug
  end

  def self.entity_parameters
    %i(body description image image_alt_text keywords language_id name nav_group title slug url)
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

  # @param [User] user
  def editable_by?(user)
    UserPrivilege.user_has_privilege?(user, :chief_editor)
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    adjacent     = self.class.find_by(priority: new_priority)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    update(priority: new_priority)

    self.class.ordered_by_priority.map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = self.class.maximum(:priority).to_i + 1
    end
  end

  def normalize_priority
    self.priority = PRIORITY_RANGE.first if priority < PRIORITY_RANGE.first
    self.priority = PRIORITY_RANGE.last if priority > PRIORITY_RANGE.last
  end
end
