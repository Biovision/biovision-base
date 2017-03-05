class PrivilegeGroupPrivilege < ApplicationRecord
  belongs_to :privilege_group
  belongs_to :privilege

  validates_uniqueness_of :privilege_id, scope: [:privilege_group_id]
end
