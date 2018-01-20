class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    unless User.table_exists?
      create_table :users do |t|
        t.timestamps
        t.integer :region_id
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.integer :inviter_id
        t.integer :native_id
        t.integer :follower_count, default: 0, null: false
        t.integer :followee_count, default: 0, null: false
        t.integer :comments_count, default: 0, null: false
        t.integer :authority, default: 0, null: false
        t.integer :upvote_count, default: 0, null: false
        t.integer :downvote_count, default: 0, null: false
        t.integer :vote_result, default: 0, null: false
        t.integer :balance, default: 0, null: false
        t.boolean :super_user, default: false, null: false
        t.boolean :deleted, default: false, null: false
        t.boolean :bot, default: false, null: false
        t.boolean :allow_login, default: true, null: false
        t.boolean :email_confirmed, default: false, null: false
        t.boolean :phone_confirmed, default: false, null: false
        t.boolean :allow_mail, default: true, null: false
        t.boolean :foreign_slug, default: false, null: false
        t.datetime :last_seen
        t.string :slug, null: false
        t.string :screen_name, index: true, null: false
        t.string :password_digest
        t.string :email, index: true
        t.string :phone
        t.string :image
        t.string :notice
        t.string :search_string
      end

      add_foreign_key :users, :users, column: :inviter_id, on_update: :cascade, on_delete: :nullify
      add_foreign_key :users, :users, column: :native_id, on_update: :cascade, on_delete: :nullify

      add_index :users, :slug, unique: true
    end
  end

  def down
    if User.table_exists?
      drop_table :users
    end
  end
end
