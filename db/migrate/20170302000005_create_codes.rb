class CreateCodes < ActiveRecord::Migration[5.1]
  def up
    unless Code.table_exists?
      create_table :codes do |t|
        t.timestamps
        t.references :code_type, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.references :user, foreign_key: true, on_update: :cascade, on_delete: :cascade
        t.references :agent, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.inet :ip
        t.integer :quantity, limit: 2, default: 1, null: false
        t.string :body, null: false
        t.string :payload
      end

      add_index :codes, [:body, :code_type_id, :quantity]
    end
  end

  def down
    if Code.table_exists?
      drop_table :codes
    end
  end
end
