class Admin::PrivilegesController < AdminController
  include LockableEntity
  include EntityPriority
  include Biovision::Admin::Privileges
end
