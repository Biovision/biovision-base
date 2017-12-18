class CreateTokens < ActiveRecord::Migration[5.1]
  def up
    unless Token.table_exists?
      create_table :tokens do |t|
        t.timestamps
        t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.datetime :last_used, index: true
        t.boolean :active, default: true, null: false
        t.string :token
      end

      add_index :tokens, :token, unique: true
    end
  end

  def down
    if Token.table_exists?
      drop_table :tokens
    end
  end
end
