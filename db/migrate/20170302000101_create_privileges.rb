class CreatePrivileges < ActiveRecord::Migration[5.1]
  def up
    return if Privilege.table_exists?

    create_table :privileges do |t|
      t.timestamps
      t.integer :parent_id
      t.boolean :locked, default: false, null: false
      t.boolean :deleted, default: false, null: false
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

    create_privileges
  end

  def down
    return unless Privilege.table_exists?

    drop_table :privileges
  end

  private

  def create_privileges
    items = {
      administrator:   'Администратор',
      metrics_manager: 'Аналитик метрик',
      moderator:       'Модератор',
      chief_editor:    'Главный редактор',
      content_manager: 'Контент-менеджер'
    }

    items.each do |slug, name|
      Privilege.create!(slug: slug, name: name, deletable: false)
    end
  end
end
