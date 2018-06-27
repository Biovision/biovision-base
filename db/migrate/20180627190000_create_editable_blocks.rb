class CreateEditableBlocks < ActiveRecord::Migration[5.2]
  def up
    unless EditableBlock.table_exists?
      create_table :editable_blocks do |t|
        t.timestamps
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.boolean :visible, default: true, null: false
        t.string :slug, null: false
        t.string :name
        t.string :image
        t.string :title
        t.text :lead
        t.text :body
        t.text :footer
      end
    end
  end

  def down
    if EditableBlock.table_exists?
      drop_table :editable_blocks
    end
  end
end
