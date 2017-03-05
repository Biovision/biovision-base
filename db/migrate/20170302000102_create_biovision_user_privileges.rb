class CreateBiovisionUserPrivileges < ActiveRecord::Migration[5.0]
  def up
    unless UserPrivilege.table_exists?
      create_table :user_privileges do |t|
        t.timestamps
        t.references :user, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.references :privilege, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
      end
    end
  end

  def down
    if UserPrivilege.table_exists?
      drop_table :user_privileges
    end
  end
end
