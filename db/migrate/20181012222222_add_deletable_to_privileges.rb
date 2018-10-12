class AddDeletableToPrivileges < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:privileges, :deletable)
      add_column :privileges, :deletable, :boolean, default: true, null: false
    end

    unless column_exists?(:privilege_groups, :deletable)
      add_column :privilege_groups, :deletable, :boolean, default: true, null: false
    end
  end

  def down
    # No rollback needed
  end
end
