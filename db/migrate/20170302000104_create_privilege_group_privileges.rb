class CreatePrivilegeGroupPrivileges < ActiveRecord::Migration[5.1]
  def up
    unless PrivilegeGroupPrivilege.table_exists?
      create_table :privilege_group_privileges do |t|
        t.timestamps
        t.references :privilege_group, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :privilege, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      end

      group = PrivilegeGroup.find_by(slug: 'editors')
      group.add_privilege(Privilege.find_by(slug: 'chief_editor'))

      group = PrivilegeGroup.find_by(slug: 'editorial_office')
      group.add_privilege(Privilege.find_by(slug: 'chief_editor'))
      group.add_privilege(Privilege.find_by(slug: 'moderator'))
    end
  end

  def down
    if PrivilegeGroupPrivilege.table_exists?
      drop_table :privilege_group_privileges
    end
  end
end
