class UserPrivilege < ApplicationRecord
  include HasOwner

  belongs_to :user
  belongs_to :privilege, counter_cache: :users_count

  validates_uniqueness_of :privilege_id, scope: [:user_id]

  # @param [User] user
  # @return [Array<Integer>]
  def self.ids(user)
    privileges = user&.privileges
    return [] if privileges.blank?
    privileges.map(&:subbranch_ids).flatten.uniq
  end

  # @param [User] user
  # @param [String|Symbol] privilege_name
  # @param [Array] region_ids
  def self.user_has_privilege?(user, privilege_name, region_ids = [])
    return false if user.nil?
    return true if user.super_user?
    privilege = Privilege.find_by(slug: privilege_name)
    privilege&.has_user?(user, region_ids)
  end

  # @param [User] user
  # @param [TrueClass|FalseClass] administrative
  def self.user_has_any_privilege?(user, administrative = true)
    return false if user.nil?
    return true if user.super_user?
    criteria = { user: user }
    if administrative
      criteria[:privilege_id] = Privilege.administrative.pluck(:id)
    end
    exists?(criteria)
  end

  # @param [User] user
  # @param [Symbol] group_name
  def self.user_in_group?(user, group_name)
    return false if user.nil?
    return true if user.super_user?
    privilege_ids = PrivilegeGroup.ids(group_name)
    return false if privilege_ids.blank?
    exists?(user: user, privilege_id: privilege_ids)
  end
end
