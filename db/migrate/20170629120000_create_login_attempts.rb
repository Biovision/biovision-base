class CreateLoginAttempts < ActiveRecord::Migration[5.1]
  def up
    unless LoginAttempt.table_exists?
      create_table :login_attempts do |t|
        t.timestamps
        t.references :user, null: false, foreign_key: { on_update: :casacde, on_delete: :cascade }
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.string :password, default: '', null: false
      end
    end
  end

  def down
    if LoginAttempt.table_exists?
      drop_table :login_attempts
    end
  end
end
