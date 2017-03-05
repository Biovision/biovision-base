module PrivilegesHelper
  # @param [Privilege] entity
  def admin_privilege_link(entity)
    link_to(entity.name, admin_privilege_path(entity.id))
  end

  # @param [PrivilegeGroup] entity
  def admin_privilege_group_link(entity)
    link_to(entity.name, admin_privilege_group_path(entity.id))
  end
end
