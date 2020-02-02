# frozen_string_literal: true

# Create table for component notifications
class CreateNotifications < ActiveRecord::Migration[5.2]
  def up
    create_notifications unless Notification.table_exists?
  end

  def down
    drop_table :notifications if Notification.table_exists?
  end

  private

  def create_notifications
    create_table :notifications, comment: 'Component notifications' do |t|
      t.uuid :uuid, null: false
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :email_sent, default: false, null: false
      t.boolean :read, default: false, null: false
      t.timestamps
      t.jsonb :data, default: {}, null: false
    end

    add_index :notifications, :uuid, unique: true
    add_index :notifications, :data, using: :gin
  end
end
