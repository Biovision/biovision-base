# frozen_string_literal: true

# Create tables for socialization component
class CreateSocializationComponent < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_user_messages unless UserMessage.table_exists?
    create_user_subscriptions unless UserSubscription.table_exists?
    create_user_bans unless UserBan.table_exists?
  end

  def down
    drop_table :user_bans if UserBan.table_exists?
    drop_table :user_subscriptions if UserSubscription.table_exists?
    drop_table :user_messages if UserMessage.table_exists?
    BiovisionComponent[Biovision::Components::SocializationComponent.slug]&.destroy
  end

  private

  def create_component
    slug = Biovision::Components::SocializationComponent.slug

    return if BiovisionComponent.where(slug: slug).exists?

    settings = {
      messages: true,
      subscriptions: true,
      bans: true
    }

    BiovisionComponent.create(slug: slug, settings: settings)
  end

  def create_user_messages
    create_table :user_messages, comment: 'Messages between users' do |t|
      t.uuid :uuid, null: false
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.timestamps
      t.boolean :read, default: false, null: false
      t.boolean :sender_deleted, default: false, null: false
      t.boolean :receiver_deleted, default: false, null: false
      t.text :body
      t.jsonb :data, default: {}, null: false
    end

    add_index :user_messages, :uuid, unique: true
    add_foreign_key :user_messages, :users, column: :sender_id, on_update: :cascade, on_delete: :cascade
    add_foreign_key :user_messages, :users, column: :receiver_id, on_update: :cascade, on_delete: :cascade
  end

  def create_user_subscriptions
    create_table :user_subscriptions, comment: 'User-to-user subscriptions' do |t|
      t.integer :follower_id, null: false
      t.integer :followee_id, null: false
      t.timestamps
    end

    add_foreign_key :user_subscriptions, :users, column: :follower_id, on_update: :cascade, on_delete: :cascade
    add_foreign_key :user_subscriptions, :users, column: :followee_id, on_update: :cascade, on_delete: :cascade
  end

  def create_user_bans
    create_table :user_bans, comment: 'Personal ban lists for users' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :other_user_id, null: false
      t.timestamps
    end

    add_foreign_key :user_bans, :users, column: :other_user_id, on_update: :cascade, on_delete: :cascade
  end
end
