class CreatePrivilegeGroupPrivileges < ActiveRecord::Migration[5.0]
  def up
    unless PrivilegeGroupPrivilege.table_exists?
      create_table :privilege_group_privileges do |t|
        t.timestamps
        t.references :privilege_group, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.references :privilege, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
      end
    end
  end

  def down
    if PrivilegeGroupPrivilege.table_exists?
      drop_table :privilege_group_privileges
    end
  end
end
