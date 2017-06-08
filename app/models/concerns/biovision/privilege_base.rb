module Biovision::PrivilegeBase
  extend ActiveSupport::Concern

  included do
    DESCRIPTION_LIMIT = 350

    belongs_to :parent, class_name: Privilege.to_s, optional: true
    has_many :children, class_name: Privilege.to_s, foreign_key: :parent_id
    has_many :user_privileges, dependent: :destroy
    has_many :users, through: :user_privileges
    has_many :privilege_group_privileges, dependent: :destroy
    has_many :privilege_groups, through: :privilege_group_privileges

    after_initialize :set_next_priority

    before_validation { self.name = name.strip unless name.nil? }
    before_validation { self.slug = Canonizer.transliterate(name.to_s) if slug.blank? }

    before_save :compact_children_cache

    validates_presence_of :name, :slug, :priority
    validates :name, uniqueness: { case_sensitive: false, scope: [:parent_id] }
    validates :slug, uniqueness: { case_sensitive: false }
    validates_length_of :description, maximum: DESCRIPTION_LIMIT

    scope :ordered_by_priority, -> { order('priority asc, name asc') }
    scope :ordered_by_name, -> { order('name asc, slug asc') }
    scope :visible, -> { where(visible: true, deleted: false) }
    scope :for_tree, ->(parent_id = nil) { where(parent_id: parent_id).ordered_by_priority }
    scope :siblings, ->(item) { where(parent_id: item.parent_id) }
  end

  # @return [String]
  def full_title
    (parents.map(&:name) + [name]).join ' / '
  end

  # @return [Array<Integer>]
  def ids
    [id] + children_cache
  end

  # @return [Array<Integer>]
  def branch_ids
    parents_cache.split(',').map(&:to_i).reject { |i| i < 1}.uniq + [id]
  end

  def parents
    if parents_cache.blank?
      []
    else
      Privilege.where(id: parents_cache.split(',').compact).order('id asc')
    end
  end

  def cache_parents!
    if parent.nil?
      self.parents_cache = ''
    else
      self.parents_cache = parent.parents_cache + ",#{parent_id}"
    end
    save!
  end

  def cache_children!
    children.order('id asc').map do |child|
      self.children_cache += [child.id] + child.children_cache
    end
    save!
    parent&.cache_children!
  end

  def can_be_deleted?
    children.count < 1
  end

  # @param [User] user
  def has_user?(user)
    return false if user.nil?
    user_privileges.exists?(user: user) || user.super_user?
  end

  # @param [User] user
  def grant(user)
    criteria = { privilege: self, user: user }
    UserPrivilege.create(criteria) unless UserPrivilege.exists?(criteria)
  end

  # @param [User] user
  def revoke(user)
    criteria = { privilege: self, user: user }
    UserPrivilege.where(criteria).destroy_all
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    adjacent     = Privilege.siblings(self).find_by(priority: new_priority)
    if adjacent.is_a?(Privilege) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    update(priority: new_priority)

    Privilege.for_tree(parent_id).map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = Privilege.siblings(self).maximum(:priority).to_i + 1
    end
  end

  def compact_children_cache
    self.children_cache.uniq!
  end

  module ClassMethods
    def page_for_administration
      ordered_by_name
    end

    def entity_parameters
      %i(name slug priority description)
    end

    def creation_parameters
      entity_parameters + %i(parent_id)
    end
  end
end
