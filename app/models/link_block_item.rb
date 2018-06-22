class LinkBlockItem < ApplicationRecord
  include Checkable
  include Toggleable

  BUTTON_TEXT_LIMIT = 50
  PRIORITY_RANGE    = (1..32767)
  SLUG_LIMIT        = 50
  SLUG_PATTERN      = /\A[a-z][-_a-z0-9]*[a-z]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z][-_a-zA_Z0-9]*[a-zA-Z]$'
  TITLE_LIMIT       = 255
  TEXT_LIMIT        = 5000
  URL_LIMIT         = 255

  toggleable :visible

  mount_uploader :image, LinkBlockImageUploader

  belongs_to :link_block

  after_initialize :set_next_priority
  before_validation { self.slug = slug.strip unless slug.nil? }
  before_validation :normalize_priority

  scope :ordered_by_priority, -> { order('priority asc, slug asc') }
  scope :siblings, -> (link_block_id) { where(lint_block_id: link_block_id) }
  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, -> { ordered_by_priority }
  scope :list_for_visitors, -> { visible.ordered_by_priority }

  def self.entity_parameters
    %i(body button_text button_url image priority slug title visible)
  end

  def self.creation_parameters
    entity_parameters + %i(link_block_id)
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    criteria     = { priority: new_priority }
    adjacent     = self.class.siblings(list_block_id).find_by(criteria)
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
