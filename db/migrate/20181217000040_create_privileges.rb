# frozen_string_literal: true

# Create tables and initial data for privileges part of users component
class CreatePrivileges < ActiveRecord::Migration[5.1]
  # Create tables and seed data
  def up
    create_privileges unless Privilege.table_exists?
    create_user_privileges unless UserPrivilege.table_exists?
    create_privilege_groups unless PrivilegeGroup.table_exists?
    create_privilege_group_links unless PrivilegeGroupPrivilege.table_exists?
  end

  # Drop tables
  def down
    drop_table :privilege_group_privileges if PrivilegeGroupPrivilege.table_exists?
    drop_table :privilege_groups if PrivilegeGroup.table_exists?
    drop_table :user_privileges if UserPrivilege.table_exists?
    drop_table :privileges if Privilege.table_exists?
  end

  private

  # Create table for Privilege model
  def create_privileges
    create_table :privileges, comment: 'Privilege' do |t|
      t.timestamps
      t.integer :parent_id
      t.boolean :administrative, default: true, null: false
      t.boolean :deletable, default: true, null: false
      t.boolean :regional, default: false, null: false
      t.integer :priority, limit: 2, default: 1, null: false
      t.integer :users_count, default: 0, null: false
      t.string :parents_cache, default: '', null: false
      t.integer :children_cache, array: true, default: [], null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description, default: '', null: false
    end

    add_foreign_key :privileges, :privileges, column: :parent_id, on_update: :cascade, on_delete: :cascade

    add_index :privileges, :slug, unique: true
  end

  # Create table for UserPrivilege model
  def create_user_privileges
    create_table :user_privileges, comment: 'Privilege for user' do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :privilege, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end

  # Create table for PrivilegeGroup model
  def create_privilege_groups
    create_table :privilege_groups, comment: 'Privilege group' do |t|
      t.timestamps
      t.boolean :deletable, default: true, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description, default: '', null: false
    end

    add_index :privilege_groups, :slug, unique: true
  end

  # Create table for PrivilegeGroupPrivilege model
  def create_privilege_group_links
    create_table :privilege_group_privileges, comment: 'Privilege in group' do |t|
      t.timestamps
      t.references :privilege_group, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :privilege, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :deletable, default: true, null: false
    end
  end
end
