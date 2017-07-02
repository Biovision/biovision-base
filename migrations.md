Миграции для обновления версий до 1.0
=====================================

Региональность (< 0.6.0.170702)
--------------

```bash
rails g migration add_regions
rails g migration add_regional_privileges
```

```ruby
class AddRegions < ActiveRecord::Migration[5.1]
  def up
    add_reference :users, :region, foreign_key: true, on_update: :cascade, on_delete: :nullify
    add_reference :user_privileges, :region, foreign_key: true, on_update: :cascade, on_delete: :cascade
    add_column :privileges, :regional, :boolean, default: false, null: false
  end

  def down
    drop_column :privileges, :regional
    drop_column :user_privileges, :region_id
    drop_column :users, :region_id
  end
end

class AddRegionalPrivileges < ActiveRecord::Migration[5.1]
  def up
    Privilege.create(slug: 'region_manager', name: 'Управляющий регионом', regional: true)
    PrivilegeGroup.create(slug: 'region_managers', name: 'Управляющие регионами')

    group = PrivilegeGroup.find_by(slug: 'region_managers')
    group.add_privilege(Privilege.find_by(slug: 'administrator'))
    group.add_privilege(Privilege.find_by(slug: 'region_manager'))
  end

  def down
    PrivilegeGroup.where(slug: 'region_managers').delete_all
    Privilege.where(slug: 'region_manager').delete_all
  end
end
```