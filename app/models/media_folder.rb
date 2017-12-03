class MediaFolder < ApplicationRecord
  include HasOwner

  NAME_LIMIT = 100
  MAX_DEPTH  = 5

  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  belongs_to :parent, class_name: MediaFolder.to_s, optional: true, touch: true
  has_many :child_categories, class_name: MediaFolder.to_s, foreign_key: :parent_id, dependent: :destroy
  has_many :media_files, dependent: :destroy

  after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }
  before_validation :calculate_depth
  before_save { self.children_cache.uniq! }
  after_save { parent.cache_children! unless parent.nil? }
  after_create :cache_parents!

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:parent_id]
  validates_length_of :name, maximum: NAME_LIMIT
  validate :parent_is_not_too_deep

  scope :ordered_by_name, -> { order('name asc') }
  scope :for_tree, ->(parent_id = nil) { where(parent_id: parent_id).ordered_by_name }

  # Allowed parameters for editing entity in controllers
  #
  # @return [Array<Symbol>]
  def self.entity_parameters
    %i(name)
  end

  # Allowed parameters for creating in controllers
  #
  # @return [Array<Symbol>]
  def self.creation_parameters
    entity_parameters + %i(parent_id)
  end

  # @return [Array<Integer>]
  def parent_ids
    parents_cache.split(',').compact.map(&:to_i)
  end

  # Parent branch ids including current id
  #
  # @return [Array<Integer>]
  def branch_ids
    parents_cache.split(',').map(&:to_i).reject { |i| i < 1 }.uniq + [id]
  end

  # Child branch (with subbranches) ids starting with current id
  #
  # @return [Array<Integer>]
  def subbranch_ids
    [id] + children_cache
  end

  def parents
    return [] if parents_cache.blank?
    MediaFolder.where(id: parent_ids).order('id asc')
  end

  # Total media file count for all children and current entity
  #
  # @return [Integer]
  def file_count
    MediaFolder.where(id: subbranch_ids).sum(:media_files_count)
  end

  def can_be_deleted?
    file_count < 1
  end

  # @param [User] user
  def editable_by?(user)
    owned_by?(user) || UserPrivilege.user_has_privilege?(user, :chief_editor)
  end

  def cache_parents!
    return if parent.nil?
    self.parents_cache = "#{parent.parents_cache},#{parent_id}".gsub(/\A,/, '')
    save!
  end

  def cache_children!
    child_categories.order('id asc').each do |child|
      self.children_cache += [child.id] + child.children_cache
    end
    save!
  end

  private

  def calculate_depth
    return if parent.nil?
    self.depth = parent.depth + 1
  end

  def parent_is_not_too_deep
    return if parent.nil?
    if parent.depth >= MAX_DEPTH
      error = I18n.t('activerecord.errors.models.media_folder.attributes.parent.is_too_deep')
      errors.add(:parent, error)
    end
  end
end
