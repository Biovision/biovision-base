class CreateMediaFiles < ActiveRecord::Migration[5.1]
  def up
    unless MediaFile.table_exists?
      create_table :media_files do |t|
        t.timestamps
        t.references :media_folder, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.references :user, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.references :agent, foreign_key: true, on_update: :cascade, on_delete: :nullify
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

  def down
    if MediaFile.table_exists?
      drop_table :media_files
    end
  end
end
