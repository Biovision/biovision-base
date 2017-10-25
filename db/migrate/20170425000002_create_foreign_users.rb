class CreateForeignUsers < ActiveRecord::Migration[5.1]
  def up
    unless ForeignUser.table_exists?
      create_table :foreign_users do |t|
        t.timestamps
        t.references :foreign_site, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.references :user, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.references :agent, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.inet :ip
        t.string :slug, null: false
        t.string :email
        t.string :name
        t.text :data
      end
    end
  end

  def down
    if ForeignUser.table_exists?
      drop_table :foreign_users
    end
  end
end
