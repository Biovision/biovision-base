class Language < ApplicationRecord
  SLUG_LIMIT     = 20
  CODE_LIMIT     = 8
  PRIORITY_RANGE = (1..999)

  has_many :users, dependent: :nullify
  has_many :user_languages, dependent: :delete_all
  has_many :editable_pages, dependent: :nullify
  has_many :feedback_requests, dependent: :nullify

  after_initialize :set_next_priority

  before_validation :normalize_priority

  validates_presence_of :code, :slug
  validates_format_of :code, with: /\A[a-z][a-z_]*[a-z]\z/i
  validates_format_of :slug, with: /\A[a-z][a-z_]+[a-z]\z/
  validates_length_of :code, maximum: CODE_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_uniqueness_of :code
  validates_uniqueness_of :slug

  scope :ordered_by_priority, -> { order('priority asc') }
  scope :active, -> { where(active: true) }

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
