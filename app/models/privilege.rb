class Privilege < ApplicationRecord
  include Checkable
  include Toggleable

  DESCRIPTION_LIMIT = 350
  NAME_LIMIT        = 250
  SLUG_LIMIT        = 250
  PRIORITY_RANGE    = (1..32_767)

  toggleable :regional, :administrative

  belongs_to :parent, class_name: Privilege.to_s, optional: true
  has_many :child_privileges, class_name: Privilege.to_s, foreign_key: :parent_id
  has_many :user_privileges, dependent: :destroy
  has_many :users, through: :user_privileges
  has_many :privilege_group_privileges, dependent: :destroy
  has_many :privilege_groups, through: :privilege_group_privileges

  after_initialize :set_next_priority

  before_validation { self.name = name.strip unless name.nil? }
  before_validation { self.slug = Canonizer.transliterate(name.to_s) if slug.blank? }
  before_validation { self.regional = true if parent&.regional? }
  before_validation :normalize_priority

  before_save { children_cache.uniq! }
  after_create :cache_parents!
  after_save { parent&.cache_children! }

  validates_presence_of :name, :slug, :priority
  validates :name, uniqueness: { case_sensitive: false, scope: [:parent_id] }
  validates :slug, uniqueness: { case_sensitive: false }
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  scope :ordered_by_priority, -> { order('priority asc, name asc') }
  scope :ordered_by_name, -> { order('name asc, slug asc') }
  scope :visible, -> { where(visible: true) }
  scope :administrative, -> { where(administrative: true) }
  scope :for_tree, ->(parent_id = nil) { where(parent_id: parent_id).ordered_by_priority }
  scope :siblings, ->(item) { where(parent_id: item.parent_id) }
  scope :list_for_administration, -> { ordered_by_name }

  def self.page_for_administration
    ordered_by_name
  end

  def self.entity_parameters
    %i[administrative description name priority regional slug]
  end

  def self.creation_parameters
    entity_parameters + %i[parent_id]
  end

  # @return [String]
  def full_title
    (parents.map(&:name) + [name]).join ' / '
  end

  # @deprecated use #subbranch_ids
  def ids
    subbranch_ids
  end

  # @return [Array<Integer>]
  def subbranch_ids
    [id] + children_cache
  end

  # @return [Array<Integer>]
  def branch_ids
    parents_cache.split(',').map(&:to_i).reject { |i| i < 1 }.uniq + [id]
  end

  def parents
    if parents_cache.blank?
      []
    else
      Privilege.where(id: parents_cache.split(',').compact).order('id asc')
    end
  end

  def cache_parents!
    return if parent.nil?

    self.parents_cache = "#{parent.parents_cache},#{parent_id}".gsub(/\A,/, '')
    save!
  end

  def cache_children!
    child_privileges.order('id asc').each do |child|
      self.children_cache += [child.id] + child.children_cache
    end
    save!
  end

  def can_be_deleted?
    deletable? && child_privileges.count < 1
  end

  # @param [User] user
  # @param [Array] region_ids
  def has_user?(user, region_ids = [])
    return false if user.nil?
    return true if user.super_user?

    result = user_in_non_regional_branch?(user)

    if regional? && region_ids.any? && !result
      result = user_in_regional_branch?(user, region_ids)
    end
    result
  end

  # @param [User] user
  # @param [Integer] region_id
  def grant(user, region_id = nil)
    return if user.nil?

    criteria             = { privilege: self, user: user }
    criteria[:region_id] = region_id if regional?
    UserPrivilege.create(criteria) unless UserPrivilege.exists?(criteria)
  end

  # @param [User] user
  # @param [Integer] region_id
  def revoke(user, region_id = nil)
    return if user.nil?

    criteria             = { privilege: self, user: user }
    criteria[:region_id] = region_id if regional?
    UserPrivilege.where(criteria).delete_all
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    criteria     = { priority: new_priority }
    adjacent     = self.class.siblings(self).find_by(criteria)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    update(priority: new_priority)

    self.class.for_tree(parent_id).map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    return unless id.nil? && priority == 1

    self.priority = self.class.siblings(self).maximum(:priority).to_i + 1
  end

  def normalize_priority
    self.priority = PRIORITY_RANGE.first if priority < PRIORITY_RANGE.first
    self.priority = PRIORITY_RANGE.last if priority > PRIORITY_RANGE.last
  end

  # @param [User] user
  def user_in_non_regional_branch?(user)
    selected_ids = Privilege.where(regional: false, id: branch_ids).pluck(:id)
    if selected_ids.any?
      UserPrivilege.exists?(privilege_id: selected_ids, user: user)
    else
      false
    end
  end

  # @param [User] user
  # @param [Array] region_ids
  def user_in_regional_branch?(user, region_ids)
    selected_ids = Privilege.where(regional: true, id: branch_ids).pluck(:id)
    if selected_ids.any?
      criteria = {
        privilege_id: selected_ids,
        region_id:    region_ids,
        user:         user
      }
      UserPrivilege.exists?(criteria)
    else
      false
    end
  end
end
