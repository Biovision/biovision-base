class PrivilegeGroup < ApplicationRecord
  include RequiredUniqueSlug
  include RequiredUniqueName

  DESCRIPTION_LIMIT = 350

  has_many :privilege_group_privileges, dependent: :destroy
  has_many :privileges, through: :privilege_group_privileges

  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  def self.page_for_administration
    ordered_by_name
  end

  # Privilege ids for group with given slug
  #
  # @param [Symbol|String]
  def self.ids(slug)
    instance = find_by(slug: slug.to_s)
    return [] if instance.nil?
    instance.privileges.map(&:ids).flatten.uniq
  end

  def self.entity_parameters
    %i(name slug description)
  end

  # @param [Privilege] privilege
  def has_privilege?(privilege)
    privilege_group_privileges.exists?(privilege: privilege)
  end

  # @param [Privilege] privilege
  def add_privilege(privilege)
    criteria = { privilege_group: self, privilege: privilege }
    return if PrivilegeGroupPrivilege.exists?(criteria)
    PrivilegeGroupPrivilege.create(criteria)
  end

  # @param [Privilege] privilege
  def remove_privilege(privilege)
    criteria = { privilege_group: self, privilege: privilege }
    PrivilegeGroupPrivilege.where(criteria).destroy_all
  end
end
