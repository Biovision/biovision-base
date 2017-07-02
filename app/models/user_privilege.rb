class UserPrivilege < ApplicationRecord
  belongs_to :user
  belongs_to :privilege, counter_cache: :users_count
  belongs_to :region, optional: true

  validates_uniqueness_of :privilege_id, scope: [:user_id, :region_id]

  # @param [User] user
  # @return [Array<Integer>]
  def self.ids(user)
    privileges = user&.privileges
    return [] if privileges.blank?
    privileges.map(&:ids).flatten.uniq
  end

  # @param [User] user
  # @param [String|Symbol] privilege_name
  # @param [Region] region
  def self.user_has_privilege?(user, privilege_name, region = nil)
    return false if user.nil?
    return true if user.super_user?
    privilege = Privilege.find_by(slug: privilege_name)
    privilege&.has_user?(user, region)
  end

  # @param [User] user
  def self.user_has_any_privilege?(user)
    return false if user.nil?
    return true if user.super_user?
    exists?(user: user)
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
