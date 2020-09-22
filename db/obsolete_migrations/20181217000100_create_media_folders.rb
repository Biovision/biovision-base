# frozen_string_literal: true

# Tables for uploaded files
class CreateMediaFolders < ActiveRecord::Migration[5.1]
  def up
    create_media_folders unless MediaFolder.table_exists?
    create_media_files unless MediaFile.table_exists?
  end

  def down
    drop_table :media_files if MediaFile.table_exists?
    drop_table :media_folders if MediaFolder.table_exists?
  end

  private

  def create_media_folders
    create_table :media_folders, comment: 'Media folder' do |t|
      t.timestamps
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.integer :parent_id
      t.integer :media_files_count, default: 0, null: false
      t.integer :depth, limit: 2, default: 0, null: false
      t.string :uuid, null: false
      t.string :snapshot
      t.string :parents_cache, default: '', null: false
      t.string :name, null: false
      t.integer :children_cache, array: true, default: [], null: false
    end

    add_foreign_key :media_folders, :media_folders, column: :parent_id, on_update: :cascade, on_delete: :cascade
  end

  def create_media_files
    create_table :media_files, comment: 'Media file' do |t|
      t.timestamps
      t.references :media_folder, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.boolean :locked, default: false, null: false
      t.string :uuid, null: false
      t.string :snapshot
      t.string :file
      t.string :mime_type
      t.string :original_name
      t.string :name, null: false
      t.string :description
    end
  end
end
