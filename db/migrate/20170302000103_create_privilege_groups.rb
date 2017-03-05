class CreatePrivilegeGroups < ActiveRecord::Migration[5.0]
  def up
    unless PrivilegeGroup.table_exists?
      create_table :privilege_groups do |t|
        t.timestamps
        t.string :name, null: false
        t.string :slug, null: false
        t.string :description, default: '', null: false
      end

      add_index :privilege_groups, :slug, unique: true
    end
  end

  def down
    if PrivilegeGroup.table_exists?
      drop_table :privilege_groups
    end
  end
end
