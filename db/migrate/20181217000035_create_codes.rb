# frozen_string_literal: true

# Tables for code types and codes
class CreateCodes < ActiveRecord::Migration[5.1]
  def up
    unless CodeType.table_exists?
      create_table :code_types, comment: 'Type of code' do |t|
        t.string :slug, null: false
        t.string :name, null: false
      end
    end

    unless Code.table_exists?
      create_table :codes, comment: 'Code for users' do |t|
        t.timestamps
        t.references :code_type, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.integer :quantity, limit: 2, default: 1, null: false
        t.string :body, null: false
        t.string :payload
        t.json :data, default: {}, null: false
      end

      add_index :codes, %i[body code_type_id quantity]
    end

    seed_items
  end

  def down
    drop_table(:codes) if Code.table_exists?
    drop_table(:code_types) if CodeType.table_exists?
  end

  private

  def seed_items
    items = {
      confirmation: 'Подтверждение почты',
      recovery: 'Сброс пароля',
      invitation: 'Приглашение'
    }

    items.each do |slug, name|
      CodeType.create(slug: slug, name: name)
    end
  end
end
