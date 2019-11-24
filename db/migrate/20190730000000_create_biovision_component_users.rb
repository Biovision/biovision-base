# frozen_string_literal: true

# Create table for user privileges in components
class CreateBiovisionComponentUsers < ActiveRecord::Migration[5.2]
  def up
    create_component_users unless BiovisionComponentUser.table_exists?
  end

  def down
    drop_table :biovision_component_users if BiovisionComponentUser.table_exists?
  end

  private

  def create_component_users
    create_table :biovision_component_users, comment: 'User privileges in component' do |t|
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
      t.boolean :administrator, default: false, null: false
      t.jsonb :data, default: { privileges: [], settings: {} }, null: false
    end

    add_index :biovision_component_users, :data, using: :gin
  end
end
