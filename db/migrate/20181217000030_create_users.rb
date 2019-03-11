# frozen_string_literal: true

# User-related tables
class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_users unless User.table_exists?
    create_tokens unless Token.table_exists?
    create_login_attempts unless LoginAttempt.table_exists?
    create_user_languages unless UserLanguage.table_exists?
    create_foreign_sites unless ForeignSite.table_exists?
    create_foreign_users unless ForeignUser.table_exists?
  end

  def down
    drop_table :foreign_users if ForeignUser.table_exists?
    drop_table :foreign_sites if ForeignSite.table_exists?
    drop_table :user_languages if UserLanguage.table_exists?
    drop_table :login_attempts if LoginAttempt.table_exists?
    drop_table :tokens if Token.table_exists?
    drop_table :users if User.table_exists?
  end

  private

  def create_users
    create_table :users, comment: 'User' do |t|
      t.uuid :uuid
      t.timestamps
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.integer :inviter_id
      t.integer :native_id
      t.integer :balance, default: 0, null: false
      t.boolean :super_user, default: false, null: false
      t.boolean :deleted, default: false, null: false
      t.boolean :bot, default: false, null: false
      t.boolean :allow_login, default: true, null: false
      t.boolean :email_confirmed, default: false, null: false
      t.boolean :phone_confirmed, default: false, null: false
      t.boolean :allow_mail, default: true, null: false
      t.boolean :foreign_slug, default: false, null: false
      t.boolean :consent, default: false, null: false
      t.datetime :last_seen
      t.date :birthday
      t.string :slug, null: false
      t.string :screen_name, index: true, null: false
      t.string :password_digest
      t.string :email, index: true
      t.string :phone
      t.string :image
      t.string :notice
      t.string :search_string
      t.string :referral_link, index: true
      t.jsonb :data, default: { profile: {} }, null: false
    end

    add_foreign_key :users, :users, column: :inviter_id, on_update: :cascade, on_delete: :nullify
    add_foreign_key :users, :users, column: :native_id, on_update: :cascade, on_delete: :nullify

    add_index :users, :slug, unique: true
    add_index :users, :data, using: :gin
  end

  def create_tokens
    create_table :tokens, comment: 'Authentication token' do |t|
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

  def create_login_attempts
    create_table :login_attempts, comment: 'Failed login attempt' do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.string :password, default: '', null: false
    end
  end

  def create_user_languages
    create_table :user_languages, comment: 'Language for user' do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end

  def create_foreign_sites
    create_table :foreign_sites, comment: 'Foreign site for OAuth' do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.integer :foreign_users_count, default: 0, null: false
    end
  end

  def create_foreign_users
    create_table :foreign_users, comment: 'User from foreign site' do |t|
      t.timestamps
      t.references :foreign_site, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.string :slug, null: false
      t.string :email
      t.string :name
      t.text :data
    end
  end
end
