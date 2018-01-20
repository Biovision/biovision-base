class CreateUserPrivileges < ActiveRecord::Migration[5.1]
  def up
    unless UserPrivilege.table_exists?
      create_table :user_privileges do |t|
        t.timestamps
        t.integer :region_id
        t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :privilege, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      end
    end
  end

  def down
    if UserPrivilege.table_exists?
      drop_table :user_privileges
    end
  end
end
