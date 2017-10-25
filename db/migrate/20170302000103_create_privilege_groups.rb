class CreatePrivilegeGroups < ActiveRecord::Migration[5.1]
  def up
    unless PrivilegeGroup.table_exists?
      create_table :privilege_groups do |t|
        t.timestamps
        t.string :name, null: false
        t.string :slug, null: false
        t.string :description, default: '', null: false
      end

      add_index :privilege_groups, :slug, unique: true

      PrivilegeGroup.create(slug: 'region_managers', name: 'Управляющие регионами')
      PrivilegeGroup.create(slug: 'editors', name: 'Редакторы')
      PrivilegeGroup.create(slug: 'editorial_office', name: 'Члены редакции')
    end
  end

  def down
    if PrivilegeGroup.table_exists?
      drop_table :privilege_groups
    end
  end
end
