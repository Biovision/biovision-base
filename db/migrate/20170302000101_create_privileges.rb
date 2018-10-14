# frozen_string_literal: true

# Create tables and initial data for privileges part of users component
class CreatePrivileges < ActiveRecord::Migration[5.1]
  # Create tables and seed data
  def up
    create_privileges unless Privilege.table_exists?
    create_user_privileges unless UserPrivilege.table_exists?
    create_privilege_groups unless PrivilegeGroup.table_exists?
    create_privilege_group_links unless PrivilegeGroupPrivilege.table_exists?

    seed_privileges
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
    create_table :privileges do |t|
      t.timestamps
      t.integer :parent_id
      t.boolean :regional, default: false, null: false
      t.boolean :administrative, default: true, null: false
      t.boolean :deletable, default: true, null: false
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
    create_table :user_privileges do |t|
      t.timestamps
      t.integer :region_id
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :privilege, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end

  # Create table for PrivilegeGroup model
  def create_privilege_groups
    create_table :privilege_groups do |t|
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
    create_table :privilege_group_privileges do |t|
      t.timestamps
      t.references :privilege_group, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :privilege, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :deletable, default: true, null: false
    end
  end

  # Create initial privileges and groups
  def seed_privileges
    groups = {
      administrators:   {
        name:        'Администраторы',
        description: 'Административная группа',
        privileges:  {
          administrator: ['Администратор', 'Может управлять пользователями и привилегиями.']
        }
      },
      analysts:         {
        name:        'Аналитики',
        description: 'Группа аналитиков различных метрик сайта',
        privileges:  {
          mertics_manager: ['Аналитик метрик', 'Может просматривать метрики.']
        }
      },
      moderators:       {
        name:        'Модераторы',
        description: 'Отвечает за пользовательский контент и блокировку пользователей',
        privileges:  {
          moderator: ['Модератор', 'Управляет блокировками пользователей и следит за пользовательским контентом.']
        }
      },
      content_managers: {
        name:        'Контент-менеджеры',
        description: 'Отвечают за наполнение информационных разделов',
        privileges:  {
          content_manager: ['Контент-менеджер', 'Редактирует информационные разделы']
        }
      }
    }

    groups.each do |slug, data|
      privilege_group = PrivilegeGroup.create!(
        slug:        slug,
        name:        data[:name],
        description: data[:description],
        deletable:   false
      )

      data[:privileges].each do |privilege_slug, privilege_data|
        privilege = Privilege.create!(
          slug:        privilege_slug,
          name:        privilege_data[0],
          description: privilege_data[1],
          deletable:   false
        )

        PrivilegeGroupPrivilege.create!(
          privilege:       privilege,
          privilege_group: privilege_group,
          deletable:       false
        )
      end
    end
  end
end
