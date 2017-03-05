module Biovision::UserPrivilege
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    belongs_to :privilege, counter_cache: :users_count

    validates_uniqueness_of :privilege_id, scope: [:user_id]
  end

  module ClassMethods
    # @param [User] user
    # @return [Array<Integer>]
    def ids(user)
      privileges = user&.privileges
      return [] if privileges.blank?
      privileges.map(&:ids).flatten.uniq
    end

    # @param [User] user
    # @param [Symbol] privilege_name
    def user_has_privilege?(user, privilege_name)
      return false if user.nil?
      return true if user.super_user?
      privilege = Privilege.find_by(slug: privilege_name.to_s)
      ids(user).include?(privilege&.id)
    end

    # @param [User] user
    def user_has_any_privilege?(user)
      return false if user.nil?
      return true if user.super_user?
      exists?(user: user)
    end

    # @param [User] user
    # @param [Symbol] group_name
    def user_in_group?(user, group_name)
      return false if user.nil?
      return true if user.super_user?
      privilege_ids = PrivilegeGroup.ids(group_name)
      return false if privilege_ids.blank?
      exists?(user: user, privilege_id: privilege_ids)
    end
  end
end
